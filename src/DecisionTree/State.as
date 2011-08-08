package DecisionTree
{
public class State
{
	protected var _hash:String;
	
	public var previous:State;
		
	public function getNext():Array 
	{
		return new Array();		
	}
		
	public function get score():Number 
	{
		return 0;
	}
	
	public function get hash():String 
	{
		return _hash;
	}
		
	public function isGoal():Boolean
	{
		return false;
	}
}
}