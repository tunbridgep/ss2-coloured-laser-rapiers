class sargeRapierReplace extends SqRootScript
{
	function OnSim()
	{
		local obj = Object.Create(-24);
		print("Created new rapier and replaced " + self);
		Object.Teleport(obj, Object.Position(self), Object.Facing(self));
		
		//Fix up Contains links
		foreach (inLink in Link.GetAll(linkkind("~Contains"),self))
		{
			local dest = sLink(inLink).dest;
			Link.Create(linkkind("~Contains"),obj,dest);
		}
		
		Object.Destroy(self);
	}
}