package test
{
import DecisionTree.DecisionTree;

import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;

import utils.IntPoint;

public class DecisionTreePathfindingTest
{		
	private var _decisionTree:DecisionTree;
	
	[Test]
	public function test3By3EmptyGrid():void
	{
		givenLevel(new Array(
			new Array(0, 0, 0),
			new Array(0, 0, 0),
			new Array(0, 0, 0)
		));
		
		whenFindingPath(new IntPoint(0, 0), new IntPoint(2, 2));
		
		thenPathLengthShouldBe(4);
	}
	
	[Test]
	public function test3By3FullGrid():void
	{
		givenLevel(new Array(
			new Array(0, 1, 1),
			new Array(1, 1, 1),
			new Array(1, 1, 1)
		));
		
		whenFindingPath(new IntPoint(0, 0), new IntPoint(2, 2));
		
		thenPathLengthShouldBe(0);
	}
	
	[Test]
	public function testBigMaze():void
	{
		givenLevel(new Array(
			new Array(0, 1, 0, 0, 0, 0),
			new Array(0, 0, 0, 1, 1, 0),
			new Array(0, 1, 1, 0, 0, 0),
			new Array(0, 1, 0, 0, 1, 1),
			new Array(0, 1, 0, 1, 0, 0),
			new Array(0, 1, 0, 0, 0, 0)
		));
		
		whenFindingPath(new IntPoint(0, 0), new IntPoint(5, 5));

		thenPathLengthShouldBe(18);
	}
	
	[Test]
	public function testBigMazeWithBlock():void
	{
		givenLevel(new Array(
			new Array(0, 0, 0, 0, 0, 0),
			new Array(0, 0, 0, 0, 1, 0),
			new Array(0, 0, 0, 0, 1, 0),
			new Array(0, 0, 0, 0, 1, 0),
			new Array(0, 0, 0, 0, 1, 0),
			new Array(0, 1, 1, 1, 1, 0),
			new Array(0, 0, 0, 0, 0, 0)
		));
		
		whenFindingPath(new IntPoint(0, 0), new IntPoint(5, 6));
		
		thenPathLengthShouldBe(11);
	}
	
	private function givenLevel(level:Array):void
	{
		PathState.level = level;
	}
	
	private function whenFindingPath(start:IntPoint, end:IntPoint):void
	{
		PathState.goal = end;
		var startState:PathState = new PathState(start);
		_decisionTree = new DecisionTree(startState);
	}

	private function getValidPath():Array
	{
		_decisionTree.improveDecision(500);
		var path:Array = _decisionTree.getDecisionPath();		
		return path;
	}
	
	private function thenPathLengthShouldBe(length:int):void
	{
		getValidPath();
		var path:Array = getValidPath();
		assertThat(path.length, equalTo(length));		
	}
}
}

import DecisionTree.State;

import utils.IntPoint;

class PathState extends State
{
	public static var goal:IntPoint;
	public static var level:Array;	
	
	private var _pos:IntPoint;
	private var _nonOptimalSteps:int;
	
	public function PathState(pos:IntPoint, nonOptimalSteps:int=0)
	{		
		_pos = pos;
		_nonOptimalSteps = nonOptimalSteps;
		_hash = pos.toString();
	}
	
	public override function getNext():Array
	{
		var next:Array = new Array();		
		addIfOpen(new IntPoint(_pos.x - 1, _pos.y), next);
		addIfOpen(new IntPoint(_pos.x + 1, _pos.y), next);
		addIfOpen(new IntPoint(_pos.x, _pos.y - 1), next);
		addIfOpen(new IntPoint(_pos.x, _pos.y + 1), next);
		return next;
	}
	
	private function addIfOpen(pos:IntPoint, next:Array):void
	{
		if (pos.y < 0 || pos.y >= level.length) return;
		if (pos.x < 0 || pos.x >= level[pos.y].length) return;		
		if (level[pos.y][pos.x] == 0) {
			var nonOptimal:int = 0;
			if (goal.x - _pos.x < goal.x - pos.x || goal.y - _pos.y < goal.y - pos.y)
				nonOptimal = 1;
			next.push(new PathState(pos, _nonOptimalSteps + nonOptimal));
		}
	}
	
	public override function isGoal():Boolean
	{
		return _pos.x == goal.x && _pos.y == goal.y;
	}
	
	public override function get score():Number
	{		
		return -_nonOptimalSteps;
	}
	
	public function toString():String
	{
		return _pos + ": " + _nonOptimalSteps;
	}
}