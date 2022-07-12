-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_conv_xml_cta_pck.obter_proced_amb ( cd_procedimento_conv_p pls_conta_item_imp.cd_procedimento_conv%type, cd_procedimento_p pls_conta_item_imp.cd_procedimento%type, ie_origem_proced_conv_p INOUT pls_conta_item_imp.ie_origem_proced_conv%type) AS $body$
DECLARE


cd_proced_conv_w	pls_conta_item_imp.cd_procedimento_conv%type;
cd_proced_number_w	pls_conta_item_imp.cd_procedimento_conv%type;
qt_procedimento_w	integer;


BEGIN

cd_proced_conv_w := cd_procedimento_conv_p;

-- verifica se existe algum procedimento com o c_digo e origem que foi identificado at_ o momento

select	count(1)
into STRICT	qt_procedimento_w
from	procedimento
where	cd_procedimento	= cd_procedimento_conv_p
and	ie_origem_proced = ie_origem_proced_conv_p;

-- se n_o existir um procedimento com o cd_procedimento e ie_origem_proced identificados

-- verifica na AMB se existe o procedimento

if (qt_procedimento_w = 0) then
	
	-- recebe o campo varchar2 que foi enviado no XML e obtem s_ numero para fazer a consulta

	cd_proced_number_w := pls_util_pck.obter_somente_numero(cd_procedimento_p);

	-- ie origem 1 AMB

	select	max(cd_procedimento)
	into STRICT	cd_proced_conv_w
	from	procedimento
	where	cd_procedimento	= cd_proced_number_w
	and	ie_origem_proced = 1
	and	ie_situacao = 'A';
	
	if (cd_proced_conv_w IS NOT NULL AND cd_proced_conv_w::text <> '') then
		ie_origem_proced_conv_p := 1;
	end if;
end if;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_conv_xml_cta_pck.obter_proced_amb ( cd_procedimento_conv_p pls_conta_item_imp.cd_procedimento_conv%type, cd_procedimento_p pls_conta_item_imp.cd_procedimento%type, ie_origem_proced_conv_p INOUT pls_conta_item_imp.ie_origem_proced_conv%type) FROM PUBLIC;
