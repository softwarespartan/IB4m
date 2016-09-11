

cd ~/Dropbox/finance/matlab/IB4m/
javaaddpath(fullfile(pwd,'Jar','TWS.jar'))

% configure buffers for contract details, market data, and options computations
[detailsBuf ,detailslh] = TWS.initBufferForEvent(TWS.Events.CONTRACTDETAILS  );
[   dataBuf ,   datalh] = TWS.initBufferForEvent(TWS.Events.MARKETDATA       ,10000);
[    optBuf ,    optlh] = TWS.initBufferForEvent(TWS.Events.OPTIONCOMPUTATION,10000);

% initialize session with TWS
session = TWS.Session.getInstance();

% connect to TWS
session.eClientSocket.eConnect('127.0.0.1',7496,0);

% create generic contract contract object
contract = com.tws.ContractFactory.GenericStockContract('IBM');

% change security type to "option"
contract.m_primaryExch = []; contract.m_secType='OPT';

% get all the details for this option
session.eClientSocket.reqContractDetails(0,contract); pause(2)

% turn hashset into cell array
e = collection2cell(detailsBuf.get().data);

% create hashmap lookup table to map requestIds back to contracts
reqTable = java.util.HashMap();

% request contract details for each contract at strike and expiry 
for i = 1:numel(e)
    
    % get the options contract object 
    optContract = e{i}.contractDetails.m_summary;
    
    % make note of the reqId and the contract
    reqTable.put(i,optContract);
    
    % request market data for this option contract at strike/expiry
    session.eClientSocket.reqMktData(i,optContract,'',false,[]);  
end

% Probably get disconnect b/c too many contract requests but you get the idea

% get cell array of options conputation events
optCompEvents = collection2cell(optBuf);

% check out your options computation content
cellfun(@(x)disp(x.data),optCompEvents)

%
% id=5  modelOptComp: vol = 0.20122100412845612 delta = -0.020743983235565658 gamma = 0.004517078896919954 vega = 0.03734590013759746 theta = -0.007482538239511609 optPrice = 0.08775570083804159 pvDividend = 1.0999211065229921 undPrice = 174.25 
% id=6  modelOptComp: vol = 0.4152890145778656 delta = -0.003890078865743068 gamma = 9.723202082912062E-4 vega = 0.003642053383587548 theta = -0.006881934600852105 optPrice = 0.014792812630342421 pvDividend = 1.0999211065229921 undPrice = 174.25
% id=8  modelOptComp: vol = 0.23454199731349945 delta = 0.001498686050653413 gamma = 2.5453071872579485E-4 vega = 0.0040910509268249785 theta = -5.771885850006268E-4 optPrice = 0.008072910592004644 pvDividend = 1.0999188527009158 undPrice = 174.25
% id=13  modelOptComp: vol = 0.19393500685691833 delta = -0.3083644830919051 gamma = 0.012634314687636419 vega = 0.506868653211316 theta = -0.018373616261642883 optPrice = 6.0972439854989595 pvDividend = 3.2963098932702994 undPrice = 174.25
% id=28  modelOptComp: vol = 0.1557130068540573 delta = -0.8097070027804582 gamma = 0.022055934776827053 vega = 0.20517932322828436 theta = -0.020708409103741086 optPrice = 13.050272280897463 pvDividend = 1.0999188527009158 undPrice = 174.25
% id=34  modelOptComp: vol = 0.0 delta = 0.999999999999999 gamma = 0.0 vega = 0.0 theta = -0.001254858724655105 optPrice = 16.75 pvDividend = 1.0999211065229921 undPrice = 174.25
% id=43  modelOptComp: vol = 0.27714601159095764 delta = 1.1626777448346167E-4 gamma = 4.321710812719872E-5 vega = 2.4287763825785072E-4 theta = -1.3649501510090557E-4 optPrice = 2.9665967152768806E-4 pvDividend = 1.0999211065229921 undPrice = 174.25
% id=45  modelOptComp: vol = 0.23369799554347992 delta = -0.15909888399150332 gamma = 0.004752141090007998 vega = 0.5544516682946439 theta = -0.009258841766196334 optPrice = 4.97909875861986 pvDividend = 7.6575228864819165 undPrice = 174.25
% id=60  modelOptComp: vol = 0.1574220061302185 delta = 0.7268339777844355 gamma = 0.05677222400216888 vega = 0.1573280319881194 theta = -0.05874440920995022 optPrice = 5.207165401523017 pvDividend = 1.0999211065229921 undPrice = 174.25
% id=73  modelOptComp: vol = 0.1461150050163269 delta = 0.9858039466142066 gamma = 0.00792116230226254 vega = 0.025488281984214822 theta = -0.008212017318217166 optPrice = 11.785496227697067 pvDividend = 1.0999211065229921 undPrice = 174.25
% id=82  modelOptComp: vol = 0.2642109990119934 delta = 0.9987860551211588 gamma = 4.96628977366534E-4 vega = 0.005115632642230139 theta = -0.002584892196876294 optPrice = 27.263420229588313 pvDividend = 1.0999211065229921 undPrice = 174.25
% id=84  modelOptComp: vol = 0.0 delta = -0.999999999999999 gamma = 0.0 vega = 0.0 theta = 0.0 optPrice = 21.79195421855792 pvDividend = 1.0999211065229921 undPrice = 174.25
% id=95  modelOptComp: vol = 0.16601599752902985 delta = -0.20810963409557096 gamma = 0.026768898497375727 vega = 0.19671823322654047 theta = -0.030003321584742053 optPrice = 1.3138575990337755 pvDividend = 1.0999208155857272 undPrice = 174.25
% id=100  modelOptComp: vol = 0.1595820039510727 delta = -0.8988038001204567 gamma = 0.007779783146699444 vega = 0.284514192872642 theta = -0.005832775926279455 optPrice = 34.65017437854918 pvDividend = 3.2963098932702994 undPrice = 174.25
% id=108  modelOptComp: vol = 0.27714601159095764 delta = 2.431650183582988E-4 gamma = 8.706126177267146E-5 vega = 5.692035909306449E-4 theta = -2.749824586044924E-4 optPrice = 6.408293842470747E-4 pvDividend = 1.0999211065229921 undPrice = 174.25
% id=130  modelOptComp: vol = 0.23728400468826294 delta = -0.06879708406765116 gamma = 0.003882402157307475 vega = 0.21833835420255632 theta = -0.008611450321088003 optPrice = 1.139312342825443 pvDividend = 3.2963098932702994 undPrice = 174.25
% id=135  modelOptComp: vol = 0.34358400106430054 delta = 0.9999590006968248 gamma = 1.68133208785124E-5 vega = 8.97792791860752E-5 theta = -0.0011803591199525652 optPrice = 35.25987571927051 pvDividend = 1.0999211065229921 undPrice = 174.25
% id=137  modelOptComp: vol = 0.1719689965248108 delta = -0.5300581373018636 gamma = 0.019857796494003353 vega = 0.4699634261460641 theta = -0.022862605860651055 optPrice = 9.584016091145026 pvDividend = 2.19886477064672 undPrice = 174.25
% id=142  modelOptComp: vol = 0.2835969924926758 delta = 0.9999999999999933 gamma = 9.356474642807977E-16 vega = 2.7000623958883807E-13 theta = -0.0010271791471262353 optPrice = 44.25894095573862 pvDividend = 1.0999211065229921 undPrice = 174.25
% id=183  modelOptComp: vol = 0.460640013217926 delta = 0.9696495404792983 gamma = 0.005428338762853705 vega = 0.01946886963941452 theta = -0.048472178467085195 optPrice = 21.916122381493587 pvDividend = 1.0999211065229921 undPrice = 174.2
% id=194  modelOptComp: vol = 0.19105100631713867 delta = 0.0 gamma = 0.0 vega = 0.0 theta = 0.0 optPrice = 0.0 pvDividend = 0.0 undPrice = 174.25
% id=198  modelOptComp: vol = 0.28584200143814087 delta = 0.999999999999999 gamma = 1.1977888777424358E-15 vega = -3.694822225952521E-13 theta = 0.0010670240076319606 optPrice = 39.25933015018933 pvDividend = 1.0999211065229921 undPrice = 174.25
% id=213  modelOptComp: vol = 0.20925599336624146 delta = 0.0 gamma = 0.0 vega = 0.0 theta = 0.0 optPrice = 0.0 pvDividend = 0.0 undPrice = 174.25
% id=1  modelOptComp: vol = 0.21957199275493622 delta = 0.02075487127505202 gamma = 0.0045151481197637415 vega = 0.02460987253182441 theta = -0.008968617692947852 optPrice = 0.08410456288604957 pvDividend = 1.0999211065229921 undPrice = 174.25
% id=217  modelOptComp: vol = 0.1949950009584427 delta = -0.043148358698023505 gamma = 0.009370380717735069 vega = 0.05653300283555682 theta = -0.014572357993730302 optPrice = 0.17854595560688755 pvDividend = 1.0999211065229921 undPrice = 174.