package marcel.utils
{
	
	/**
	 * Interface for objects that are destroyable.
	 * @author Alexandre Croiseaux
	 */
	public interface IDestroyable
	{
		/**
		 * Implementation of this method must remove any event listeners and stops all internal processes to help allow for prompt garbage collection.
		 */
		function destroy():void;
	}
	
}