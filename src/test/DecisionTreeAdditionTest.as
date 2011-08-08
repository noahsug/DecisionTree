package test
{
import org.flexunit.asserts.assertEquals;
import DecisionTree.DecisionTree;

public class DecisionTreeAdditionTest
{		
	private var _decisionTree:DecisionTree;
	
	[Test]
	public function testSingleAddition():void
	{
		givenStartingValue(1);
		
		whenEndingValueIs(4);
		
		thenDecisionPathShouldBe("+");
	}
	
	[Test]
	public function testAdditionMultiplication():void
	{
		givenStartingValue(0);
		
		whenEndingValueIs(9);
		
		thenDecisionPathShouldBe("+*");
	}
	
	
	[Test]
	public function testTripleAddition():void
	{
		givenStartingValue(1);
		
		whenEndingValueIs(10);
		
		thenDecisionPathShouldBe("+++");
	}
	
	[Test]
	public function testAdditionMultiplicationSubtraciton():void
	{
		givenStartingValue(1);
		
		whenEndingValueIs(-3);
		
		thenDecisionPathShouldBe("-*+");
	}

	private function givenStartingValue(startingValue:int):void
	{		
		CalculatorState.goal = startingValue + 1;
		var startingNode:CalculatorState = new CalculatorState(startingValue);
		_decisionTree = new DecisionTree(startingNode);
	}
	
	private function whenEndingValueIs(endingValue:int):void
	{		
		CalculatorState.goal = endingValue;
	}
	
	private function thenDecisionPathShouldBe(operations:String):void
	{		
		_decisionTree.improveDecision(50);		
		var decisionPath:Array = _decisionTree.getDecisionPath();		
		var actual:String = "";
		for each(var state:CalculatorState in decisionPath) {
			actual += state.getName();
		}
		assertEquals(operations, actual);		
	}
}
}

import DecisionTree.State;

class CalculatorState extends State
{
	public static var goal:int;
	
	private var _value:int;
	private var _steps:int;
	private var _operationName:String;
	private var _score:Number;
	
	public function CalculatorState(value:int, operationName:String="start", steps:int=0)
	{
		_operationName = operationName;
		_value = value;
		_steps = steps;
		_hash = ""+value;
		
		calculateScore();
	}
	
	private function calculateScore():void
	{
		if (_value == goal)
			_score = int.MAX_VALUE - _steps;
		else {
			_score = -(Math.abs(goal - _value) + _steps);
		}
	}
	
	public override function getNext():Array
	{
		var next:Array = new Array();
		if (goal < _value) {
			if (_value < 0)
				next.push(new CalculatorState(_value * 3, "*", _steps + 1));
			next.push(new CalculatorState(_value - 3, "-", _steps + 1));
		} else {
			if (_value > 0)
				next.push(new CalculatorState(_value * 3, "*", _steps + 1));			
			next.push(new CalculatorState(_value + 3, "+", _steps + 1));
		}
		return next;
	}
		
	public override function isGoal():Boolean
	{
		return false;
	}
	
	public override function get score():Number
	{		
		return _score;	
	}
	
	public function getName():String
	{
		return _operationName;
	}
	
	public function toString():String
	{
		return _value + " + " + _steps + " = " + score + " (" + _operationName + ")";
	}
}