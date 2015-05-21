# eDOCS WCF sample script to login onto an eDOCS DM Library using its WCF service
# Make sure the eDCOS WCF service has been activated in the eDOCS server administrator
# on the eDOCS server. 
# This script requires at least PowerShell 3.
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

# Load my own eDOCS WCF client proxy DLL
add-type -LiteralPath (Join-Path $PSScriptRoot 'DMSvrInteropSvcImpl.dll')

# Create the client proxy for the SVC port
$binding = new-object 'System.Servicemodel.BasicHttpBinding'
$binding.MaxReceivedMessageSize = 0x7fffffff;
$binding.ReaderQuotas.MaxArrayLength = 0x7fffffff;
$binding.ReaderQuotas.MaxStringContentLength = 0x7fffffff;
$addr = new-object System.ServiceModel.EndpointAddress('http://10.30.10.30:8080/DMSvr/Svc');
$newSvcClient = New-Object DMSvcClient($bindingObj, $addrObj)


try
{ 
	# Prepare the loginInfo structure
	$loginInfo = new-object OpenText.DMSvr.Serializable.DMSvrLoginInfo
	$loginInfo.username = 'ADMINISTRATOR'
	$loginInfo.password = 'mypasswordismyvoice'
	$loginInfo.loginContext = "SAMPLELIB"
	$loginInfo.network = 0

	# Prepare the loginCall structure, with the single loginInfo
	$logincall = new-object OpenText.DMSvr.InteropSvc.LoginCallSvr5
	$logincall.dstIn = ''
	$logincall.loginInfo = ,$loginInfo
	$logincall.authen = 1

	# Do the login call to the eDOCS WCF service
	$loginReply = $newSvcClient.LoginSvr5($logincall)

	# Output the reply
	$loginReply
	$loginReply.loginProperties.propertyNames
	$loginReply.loginProperties.propertyValues

    $newSvcClient.Close()
}
catch
{
    $newSvcClient.Abort()
    throw
}
