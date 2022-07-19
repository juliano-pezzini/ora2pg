-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_verificar_inadimp_contrato (( nr_seq_contrato_p bigint, ie_acao_regra_p out text, ds_mensagem_p out text) is cd_estabelecimento_w estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


qt_titulo_inadimp_w		bigint;	

BEGIN

select	count(1)
into STRICT	qt_titulo_inadimp_w
from	titulo_receber
where	((cd_pessoa_fisica = cd_pessoa_fisica_p) or (cd_cgc = cd_cgc_p))
and (dt_pagamento_previsto + coalesce(qt_dias_vencimento_p,0)) < trunc(clock_timestamp(), 'dd')
and	ie_situacao = 1
and	cd_estabelecimento = cd_estabelecimento_w;

return;

end;

procedure realizar_acao_regra(	ie_acao_regra_p	varchar2,
				ds_pagador_p	varchar2) is
begin

if (ie_acao_regra_p in ('R', 'E')) then
	ie_acao_regra_w	:= ie_acao_regra_p;

	if (ds_pagador_p IS NOT NULL AND ds_pagador_p::text <> '') then
		ds_mensagem_w	:= ds_pagador_p ||' possui título(s) inadimplente(s)! Deseja continuar?';
	else
		ds_mensagem_w	:= 'Este estipulante possui título(s) inadimplente(s)! Deseja continuar?';
	end if;
	
	if (ie_acao_regra_w = 'R') then	 --Emite mensagem de alerta
		if (ds_pagador_p IS NOT NULL AND ds_pagador_p::text <> '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1067061, 'DS_PAGADOR='||ds_pagador_p);
		else	
			CALL wheb_mensagem_pck.exibir_mensagem_abort(137157);
		end if;
	end if;	
end if;

end;
	
begin

cd_estabelecimento_w 	:= wheb_usuario_pck.get_cd_estabelecimento;
ie_acao_regra_w		:= 'N';
ds_mensagem_w		:= null;

select	cd_pf_estipulante,
	cd_cgc_estipulante,
	CASE WHEN coalesce(cd_pf_estipulante::text, '') = '' THEN 'PJ'  ELSE 'PF' END  ie_tipo_contrato
into STRICT	cd_pessoa_fisica_w,
	cd_cgc_w,
	ie_tipo_contrato_w
from	pls_contrato
where	nr_sequencia = nr_seq_contrato_p;

for r_c01_w in c01(ie_tipo_contrato_w, cd_estabelecimento_w) loop
	begin
	if (r_c01_w.ie_pessoa_consistir in ('E', 'A') and (verificar_titulo_inadimp(cd_pessoa_fisica_w, cd_cgc_w, r_c01_w.qt_dias_vencimento) > 0)) then
		realizar_acao_regra(r_c01_w.ie_acao_regra, null);
	end if;
	
	if (r_c01_w.ie_pessoa_consistir in ('P', 'A')) then
		for r_c02_w in c02(nr_seq_contrato_p) loop
			begin
			if (verificar_titulo_inadimp(r_c02_w.cd_pessoa_fisica, r_c02_w.cd_cgc, r_c01_w.qt_dias_vencimento) > 0) then
				realizar_acao_regra(r_c01_w.ie_acao_regra, r_c02_w.ds_pagador);
			end if;
			end;
		end loop;
	end if;
	end;
end loop;

ie_acao_regra_p	:= ie_acao_regra_w;
ds_mensagem_p	:= ds_mensagem_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_verificar_inadimp_contrato (( nr_seq_contrato_p bigint, ie_acao_regra_p out text, ds_mensagem_p out text) is cd_estabelecimento_w estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

