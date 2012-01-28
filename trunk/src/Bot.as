package
{
	import org.flixel.*;

	public class Bot extends Hydraman
	{
		public function Bot(old_player:Player)
		{
			super(old_player.startX, old_player.startY);
			copyPowerups(old_player);
			m_stateHistory = new Array();
			for each (var thing in old_player.m_stateHistory)
				m_stateHistory.push(thing);
			m_run_level = old_player.m_run_level;
			m_stamina_level = old_player.m_stamina_level;
		}
		
		override public function update():void
		{
			if (m_stateHistory.length > 1)
			{
				var state:int = m_stateHistory[0];
				var time:Number = m_stateHistory[1];
				if (time >= m_timeLeft)
				{
					m_stateHistory.shift();
					m_stateHistory.shift();
					setState(state);
				}
			}
			super.update();
		}
	}
}