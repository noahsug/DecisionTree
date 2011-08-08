package
{
import Array;

import flash.display.Sprite;

import flexunit.flexui.FlexUnitTestRunnerUIAS;

import test.DecisionTreeAdditionTest;
import test.DecisionTreePathfindingTest;

public class FlexUnitApplication extends Sprite
{
	public function FlexUnitApplication()
	{
		onCreationComplete();
	}
	
	private function onCreationComplete():void
	{
		var testRunner:FlexUnitTestRunnerUIAS=new FlexUnitTestRunnerUIAS();
		this.addChild(testRunner); 
		testRunner.runWithFlexUnit4Runner(currentRunTestSuite(), "AIChallenge");
	}
	
	public function currentRunTestSuite():Array
	{
		var testsToRun:Array = new Array();
		testsToRun.push(test.DecisionTreeAdditionTest);
		testsToRun.push(test.DecisionTreePathfindingTest);
		return testsToRun;
	}
}
}