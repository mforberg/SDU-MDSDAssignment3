/*
 * generated by Xtext 2.21.0
 */
package sdu.mdsd.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import sdu.mdsd.assignment3.MathExp
import sdu.mdsd.assignment3.Plus
import sdu.mdsd.assignment3.Minus
import sdu.mdsd.assignment3.Mult
import sdu.mdsd.assignment3.Div
import sdu.mdsd.assignment3.Expression
import sdu.mdsd.assignment3.Num
import java.util.HashMap
import java.util.Map
import sdu.mdsd.assignment3.Var
import sdu.mdsd.assignment3.Let
import sdu.mdsd.assignment3.Expressions
//import sdu.mdsd.assignment3.External
import sdu.mdsd.assignment3.Ext

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class Assignment3Generator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		val math = resource.allContents.filter(Expressions).next

		fsa.generateFile("MathComputation.java", math.generateMathCodeWithExternal)
	}
	

	
	def CharSequence generateMathCodeWithExternal(Expressions expressions) {
		'''
		import java.util.*
		
		public class MathComputation {

			�IF containsExternal(expressions)�
			public static interface Externals {
				public int power(int base, int exponent);
			}

			private Externals externals;

			public MathComputation(Externals _externals) {
				externals = _externals;
			}
			�ELSE�
			public MathComputation() {
				
			}
			�ENDIF�

			public void calculate() {
				�FOR exp : expressions.getExpressions�
				System.out.println("�exp.getVarName� " + �exp.compute�);
				�ENDFOR�	
			}

		}
		'''
		
	}
	
	def boolean containsExternal(Expressions expressions) {
		
		for (e : expressions.getExpressions) {
			//System.out.println("called")
			//System.out.println(typeof(Ext))
			//System.out.println(typeof(Plus))
			if(e.exp instanceof Ext) {
				//System.out.println("match")
				return true
			}
		}
		
		return false
	}
	
	
	
	def int compute(MathExp math) { 
		math.exp.computeExp(new HashMap<String,Integer>)
	}
	
	def int computeExp(Expression exp, Map<String,Integer> env) {
		switch exp {
			Plus: exp.left.computeExp(env)+exp.right.computeExp(env)
			Minus: exp.left.computeExp(env)-exp.right.computeExp(env)
			Mult: exp.left.computeExp(env)*exp.right.computeExp(env)
			Div: exp.left.computeExp(env)/exp.right.computeExp(env)
			Num: exp.value
			Var: env.get(exp.id)
			Ext: {
				//I don't know if there's a better way to do power of?
				var result = exp.base
				for(var i = 1; i < exp.exponent; i++) {
					result = result*exp.base
				}
				result
			}
			Let: exp.body.computeExp(env.bind(exp.id,exp.binding.computeExp(env)))
			default: throw new Error("Invalid expression")
		}
	}
	
	def Map<String, Integer> bind(Map<String, Integer> env1, String name, int value) {
		val env2 = new HashMap<String,Integer>(env1)
		env2.put(name,value)
		env2 
	}
	
		
}