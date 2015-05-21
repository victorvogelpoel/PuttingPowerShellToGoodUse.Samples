# eDOCS_COM_GetDMLoginLibrary.ps1
# Get the eDOCS DM login libries.
# 
# IMPORTANT: this script can only execute in a 32-bit PowerShell session on a computer where the
# Open Text eDOCS DM extensions have been installed.
# 
# If script works, it was written by Victor Vogelpoel (victor.vogelpoel@the-one-solutions.com)
# If it doesn't, I do not know who wrote is.
#
# THIS PROGRAM IS FREE SOFTWARE. IN NO EVENT SHALL VICTOR VOGELPOEL AND THE ONE BE LIABLE TO ANY PARTY 
# FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS,
# ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF VICTOR VOGELPOEL AND THE ONE
# HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# VICTOR VOGELPOEL AND THE ONE SPECIFICALLY DISCLAIM ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE AND 
# ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED HEREUNDER IS PROVIDED "AS IS". VICTOR VOGELPOEL AND
# THE ONE HAVE NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

if ([IntPtr]::Size -ne 4)
{
	Write-Warning 'This PowerShell session is not 32-bit. The eDOCS COM calls may fail.'
}

# Load the eDOCS DM interop
add-type -path "C:\Program Files\Open Text\DM Extensions\Hummingbird.DM.Server.Interop.PCDClient.dll"

$PDCLoginLibs = New-object Hummingbird.DM.Server.Interop.PCDClient.PCDGetLoginLibsClass
$rc = $PDCLoginLibs.Execute()
if ($rc -ne 0)
{
	$errorMessage = "ERROR $rc while querying eDOCS loginlibraries: $($PDCLoginLibs.ErrDescription)"
	throw $errorMessage
}

$libraries = for ($i=0; $i -lt $PDCLoginLibs.GetSize(); $i++) { $PDCLoginLibs.GetAt($i) }
# $libraries now contains an array of eDOCS libraries
	