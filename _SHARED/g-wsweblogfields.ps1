[cmdletbinding(PositionalBinding=$false)]
	Param(
	   [parameter(Mandatory=$false, ValueFromPipeline=$false)]
	   [string] $ServerName
	   )
	 
	Process {
	 
	   $script = {
	      Import-Module -Name WebAdministration;
	 
	      GCI IIS:\Sites |%{
	         $site=$_;
	         $SiteName=$site.name;
	         $fields=$site.logFile.logExtFileFlags;
	         $custfld=$site.logFile.customFields.Collection |?{ $_.logFieldName -eq 'X-Forwarded-For' };
             
	         if ($custfld)
	            { $cust = "$($custfld.logFieldName)=$($custfld.sourceType)($($custfld.sourceName))"; }
	         else
	            { $cust='' };
	         [PSCustomObject]@{Site=$SiteName;Fields=$fields;Custom=$cust};
	         }
	      }
	 


	   if ($ServerName)
	      {
	      icm -ComputerName $ServerName -ScriptBlock $script | ft PSComputerName,Site,Fields,Custom;
	      }
	   else
	      {
	      icm -ScriptBlock $script | ft Site,Fields,Custom;
	      }
	 
	}
