package DecisionTree
{

public class DecisionTree
{
	private var _openStateSize:int;
	private var _openStates:Object;	  // HashMap
	private var _closedStates:Object; // hashSet
	private var _currentState:State;
	private var _bestState:State;
	private var _hasMadeBestDecision:Boolean;

	public function DecisionTree(startingState:State)
	{
		_openStates = new Object();
		_closedStates = new Object();
		_closedStates[startingState.hash] = true;
		_currentState = _bestState = startingState;
		_openStateSize = 0;
		_hasMadeBestDecision = false;
	}

	public function improveDecision(iterations:int=1):void
	{
		for (var i:int = 0; i < iterations; i++) {
			if (hasMadeBestDecision()) break;
			var nextStates:Array = _currentState.getNext();
			addNewStates(nextStates);
			updateCurrentState();
		}		
	}

	public function hasMadeBestDecision():Boolean
	{
		return _hasMadeBestDecision;
	}

	private function addNewStates(states:Array):void
	{
		for each(var nextState:State in states) {
			if (stateIsClosed(nextState))
				continue;
			var equivalentState:State = _openStates[nextState.hash];
			if (!equivalentState || equivalentState.score < nextState.score) {
				nextState.previous = _currentState;
				addToOpenStates(nextState);
			}
		}
	}

	private function closeState(state:State):void
	{
		_closedStates[state.hash] = true;
	}

	private function stateIsClosed(state:State):Boolean
	{
		return _closedStates[state.hash];
	}

	private function addToOpenStates(state:State):void
	{
		_openStateSize++;
		_openStates[state.hash] = state;
	}

	private function removeFromOpenStates(state:State):void
	{
		_openStateSize--;
		delete _openStates[state.hash];
	}

	private function updateCurrentState():void
	{
		if (_openStateSize == 0) {
			_hasMadeBestDecision = true;
			return;
		}

		_currentState = popBestOpenState();
		closeState(_currentState);
		if (_currentState.isGoal()) {
			_bestState = _currentState;
			_hasMadeBestDecision = true;
		} else if (_currentState.score > _bestState.score) {
			_bestState = _currentState;
		}
	}

	private function popBestOpenState():State
	{
		var bestOpenState:State;
		for (var key:String in _openStates) {
			var openState:State = _openStates[key];
			if (!bestOpenState || openState.score > bestOpenState.score) {
				bestOpenState = openState;
			}
		}
		removeFromOpenStates(bestOpenState);
		return bestOpenState;
	}

	public function getDecisionPath():Array
	{
		var decisionPath:Array = new Array();
		var state:State = _bestState;
		do {
			decisionPath.push(state);
			state.previous;
		} while (state = state.previous);
		decisionPath.pop();
		decisionPath.reverse();
		return decisionPath;
	}

	public function getDecision():State
	{
		return getDecisionPath()[0];
	}
}
}