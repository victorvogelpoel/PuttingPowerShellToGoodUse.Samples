# eDOCS WCF sample script get the eDOCS login libraries its WCF service.
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
$bindingObj = new-object 'System.Servicemodel.BasicHttpBinding'
$bindingObj.MaxReceivedMessageSize = 0x7fffffff;
$bindingObj.ReaderQuotas.MaxArrayLength = 0x7fffffff;
$bindingObj.ReaderQuotas.MaxStringContentLength = 0x7fffffff;
$addrObj = new-object System.ServiceModel.EndpointAddress('http://10.30.10.30:8080/DMSvr/Svc');
$newSvcClient = New-Object DMSvcClient($bindingObj, $addrObj)

try
{
    $loginlibrariesCall = New-Object OpenText.DMSvr.InteropSvc.GetLoginLibrariesCall
    $loginLibrariesReply = $newSvcClient.GetLoginLibraries($loginlibrariesCall)

    # Output the reply object
    $loginLibrariesReply | ft -AutoSize

    $newSvcClient.Close()
}
catch
{
    $newSvcClient.Abort()
    throw
}
