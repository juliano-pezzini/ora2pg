-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_eis_hist_audit_conpaci (dt_parametro_p timestamp) AS $body$
DECLARE

 
 
dt_parametro_w		timestamp;
dt_pagamento_previsto_w	timestamp;
ie_tipo_vencimento_w	smallint;

cd_estabelecimento_w	titulo_receber.cd_estabelecimento%type;
cd_convenio_w		titulo_receber.cd_convenio_conta%type;
nr_titulo_w		titulo_receber.nr_titulo%type;
nr_interno_conta_w	conta_paciente.nr_interno_conta%type;
vl_historico_w		conta_paciente_ret_hist.vl_historico%type;
nr_seq_historico_w	hist_audit_conta_paciente.nr_sequencia%type;
ie_tipo_convenio_w	convenio.ie_tipo_convenio%type;
ds_convenio_w		convenio.ds_convenio%type;
cd_portador_w		cobranca.cd_portador%type;
cd_tipo_portador_w	cobranca.cd_tipo_portador%type;

c01 CURSOR FOR 
SELECT	cd_estabelecimento, 
	coalesce(coalesce(cd_convenio_conta, obter_convenio_tit_rec(nr_titulo)), 0), 
	dt_pagamento_previsto, 
	nr_titulo 
from 	titulo_receber 
where	dt_contabil 		<= dt_parametro_w 
and	ie_situacao 		<> '5' 
and (ie_situacao 		<> '3' or (dt_liquidacao > dt_parametro_w or coalesce(dt_liquidacao::text, '') = '')) 
and	((coalesce(dt_liquidacao::text, '') = '') or (dt_liquidacao > dt_parametro_w)) 
group by cd_estabelecimento, 
	coalesce(coalesce(cd_convenio_conta, obter_convenio_tit_rec(nr_titulo)), 0), 
	dt_pagamento_previsto, 
	nr_titulo 
order by 1;

c02 CURSOR FOR 
SELECT	a.nr_interno_conta, 
	b.vl_historico, 
	b.nr_seq_hist_audit nr_seq_historico 
from	convenio_retorno_item a,	 
	conta_paciente_ret_hist b, 
	hist_audit_conta_paciente c 
where	b.nr_seq_hist_audit		= c.nr_sequencia 
and	a.nr_sequencia			= b.nr_seq_ret_item 
and	c.ie_acao			<> 3 --Não considera os históricos de glosa devido (pois este valor não esta pendente) 
and	a.nr_titulo			= nr_titulo_w 
and	(b.nr_seq_conpaci_ret IS NOT NULL AND b.nr_seq_conpaci_ret::text <> '');
	
c03 CURSOR FOR 
SELECT	b.nr_interno_conta, 
	a.cd_portador, 
	a.cd_tipo_portador, 
	sum(coalesce(a.vl_acobrar,0) + coalesce(obter_valor_terc_cobranca(a.nr_sequencia),0) + coalesce(a.vl_juros_cobr,0)) 
from	cobranca a, 
	titulo_receber b 
where	a.nr_titulo	= b.nr_titulo 
and	a.nr_titulo	= nr_titulo_w 
and	a.ie_status	in ('P','R','N') -- Somente, se 'Pendente','Perda' ou 'Negociada' 
group by b.nr_interno_conta, 
	a.cd_portador, 
	a.cd_tipo_portador;


BEGIN 
 
dt_parametro_w	:= trunc(dt_parametro_p,'dd');
 
delete from eis_hist_audit_conpaci 
where dt_referencia	= dt_parametro_w;
 
open C01;
loop 
fetch C01 into 
	cd_estabelecimento_w, 
	cd_convenio_w, 
	dt_pagamento_previsto_w, 
	nr_titulo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	if (cd_convenio_w <> 0) then 
 
		if (dt_pagamento_previsto_w >= dt_parametro_w - 15) then 
			ie_tipo_vencimento_w	:= 6;
		elsif (dt_pagamento_previsto_w >= dt_parametro_w- 30) then 
			ie_tipo_vencimento_w	:= 7;
		elsif (dt_pagamento_previsto_w >= dt_parametro_w- 60) then 
			ie_tipo_vencimento_w	:= 8;
		elsif (dt_pagamento_previsto_w >= dt_parametro_w - 90) then 
			ie_tipo_vencimento_w	:= 9;
		elsif (dt_pagamento_previsto_w >= dt_parametro_w - 120) then 
			ie_tipo_vencimento_w	:= 12;
		else 
			ie_tipo_vencimento_w	:= 10;
		end if;		
 
		select	max(ie_tipo_convenio), 
			substr(max(ds_convenio),1,255) 
		into STRICT	ie_tipo_convenio_w, 
			ds_convenio_w 
		from	convenio 
		where	cd_convenio	= cd_convenio_w;
 
		if (ie_tipo_convenio_w <> 1) then --Não particulares 
 
			open C02;
			loop 
			fetch C02 into 
				nr_interno_conta_w, 
				vl_historico_w, 
				nr_seq_historico_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin 
 
				insert into eis_hist_audit_conpaci(cd_convenio, 
					ds_convenio, 
					nr_seq_historico, 
					cd_portador, 
					cd_tipo_portador, 
					nr_interno_conta, 
					vl_historico, 
					ie_tipo_vencimento, 
					dt_referencia, 
					cd_estabelecimento) 
				values (cd_convenio_w, 
					ds_convenio_w, 
					nr_seq_historico_w, 
					null, 
					null, 
					nr_interno_conta_w, 
					vl_historico_w, 
					ie_tipo_vencimento_w, 
					dt_parametro_w, 
					cd_estabelecimento_w);
 
				end;
			end loop;
			close C02;
 
		else 
		 
			open C03;
			loop 
			fetch C03 into	 
				nr_interno_conta_w, 
				cd_portador_w, 
				cd_tipo_portador_w, 
				vl_historico_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin 
				 
				insert into eis_hist_audit_conpaci(cd_convenio, 
					ds_convenio, 
					nr_seq_historico, 
					cd_portador, 
					cd_tipo_portador, 
					nr_interno_conta, 
					vl_historico, 
					ie_tipo_vencimento, 
					dt_referencia, 
					cd_estabelecimento) 
				values (cd_convenio_w, 
					ds_convenio_w, 
					null, 
					cd_portador_w, 
					cd_tipo_portador_w, 
					nr_interno_conta_w, 
					vl_historico_w, 
					ie_tipo_vencimento_w, 
					dt_parametro_w, 
					cd_estabelecimento_w);				
				 
				end;
			end loop;
			close C03;
 
		end if;
	end if;
 
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_eis_hist_audit_conpaci (dt_parametro_p timestamp) FROM PUBLIC;
