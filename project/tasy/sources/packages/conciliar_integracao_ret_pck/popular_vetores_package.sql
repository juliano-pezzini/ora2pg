-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE conciliar_integracao_ret_pck.popular_vetores () AS $body$
DECLARE


cursor_protocolo CURSOR FOR
SELECT	nr_lote_prestador,
	coalesce(nr_seq_protocolo,0) nr_protoc_tasy,
	nr_protocolo_operadora,
	nr_sequencia,
	cd_convenio,
	cd_estabelecimento,
	nr_seq_retorno_conv,
	vl_informado,
	vl_liberado,
	dt_pagamento,
	nr_seq_imp_dem_retorno
from	imp_dem_retorno_prot a
where (coalesce(a.ie_status, ie_status_pendente_const_w) 	= ie_status_pendente_const_w
or	    coalesce(a.ie_status, 'P') 	= 'V')
and	a.nr_seq_imp_dem_retorno  = 	(select distinct(x.nr_sequencia)
					from 	imp_dem_retorno x,
						imp_dem_retorno_prot y
					where	x.nr_sequencia	= y.nr_seq_imp_dem_retorno
					and	x.nr_sequencia	= coalesce(nr_seq_lote_w, x.nr_sequencia)
					and (coalesce(y.ie_status, ie_status_pendente_const_w) = ie_status_pendente_const_w
                    or  coalesce(y.ie_status, ie_status_pendente_const_w) = 'V'))
order by a.nr_sequencia;

cursor_contas CURSOR FOR
SELECT	coalesce(nr_interno_conta,0) nr_conta,
	nr_guia_operadora nr_operadora,
	nr_guia_prestador nr_guia_prest,
	cd_senha cd_senha,
	nr_seq_conta_guia nr_seq_conta_guia,
	vl_informado,
	nr_sequencia,
	nr_guia_operadora cd_autorizacao,
	coalesce(ie_status, 'P') ie_status
from	imp_dem_retorno_guia
where	nr_seq_dem_ret_prot = current_setting('conciliar_integracao_ret_pck.nr_seq_dem_ret_prot_w')::imp_dem_retorno_prot.nr_sequencia%type
and (coalesce(ie_status,'P') = ie_status_pendente_const_w
or	coalesce(ie_status,'V') = 'V');

cursor_tiss_conta_guia CURSOR FOR
SELECT	a.nr_interno_conta,		
	a.cd_autorizacao,			
	a.nr_guia_prestador,		
	a.cd_senha,			
	a.vl_total,
	a.nr_sequencia,
	b.nr_sequencia nr_seq_prot_tiss
from	tiss_conta_guia a,
	tiss_protocolo_guia b
where	a.nr_seq_prot_guia = b.nr_sequencia
and	b.nr_seq_protocolo = current_setting('conciliar_integracao_ret_pck.nr_seq_protocolo_w')::imp_dem_retorno_prot.nr_seq_protocolo%type;

nr_seq_convenio_retorno_w	convenio_retorno.nr_sequencia%type;

cursor_protocolo_row 		cursor_protocolo%rowtype;
cursor_contas_row		cursor_contas%rowtype;
cursor_tiss_conta_guia_row	cursor_tiss_conta_guia%rowtype;

i 		integer;
j 		integer;
k 		integer;

ie_status_w 	varchar(2);
qt_protocolo_w	bigint;


BEGIN
	i := 0;	
	for cursor_protocolo_row in cursor_protocolo loop
	
		current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].nr_sequencia 			:= cursor_protocolo_row.nr_sequencia;
		current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].nr_seq_protocolo 		:= cursor_protocolo_row.nr_protoc_tasy;
		current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].nr_protocolo_operadora 		:= cursor_protocolo_row.nr_protocolo_operadora;
		current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].cd_convenio			:= cursor_protocolo_row.cd_convenio;
		current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].cd_estabelecimento 		:= cursor_protocolo_row.cd_estabelecimento;
		current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].vl_liberado			:= cursor_protocolo_row.vl_liberado;
		current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].vl_informado			:= cursor_protocolo_row.vl_informado;
		current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].dt_pagamento			:= cursor_protocolo_row.dt_pagamento;
		current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].nr_seq_imp_dem_retorno		:= cursor_protocolo_row.nr_seq_imp_dem_retorno;
		current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].nr_lote_prestador		:= cursor_protocolo_row.nr_lote_prestador;
		
		nr_seq_convenio_retorno_w := conciliar_integracao_ret_pck.locate_insurance_return_seq(current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v(i), nr_seq_convenio_retorno_w);
		
		current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].nr_seq_retorno_conv		:= nr_seq_convenio_retorno_w;
		
		update 	imp_dem_retorno_prot
		set	nr_seq_retorno_conv = nr_seq_convenio_retorno_w
		where	nr_sequencia = current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].nr_sequencia;

		update	convenio_retorno
		set	ds_observacao	= obter_desc_expressao(953980)
		where	nr_sequencia	= current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].nr_seq_retorno_conv;

		if (current_setting('conciliar_integracao_ret_pck.ie_opcao_w')::varchar(2) = 'V') then
		    ie_status_w := 'V';
		else
		    ie_status_w := 'C';
		end if;

		if (current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].nr_seq_protocolo > 0) then

			select 	coalesce(count(1),0)
			into STRICT	qt_protocolo_w	
			from 	protocolo_convenio
			where	nr_seq_protocolo 	= current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].nr_seq_protocolo
			and	cd_convenio 		= current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].cd_convenio
			and	cd_estabelecimento 	= current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].cd_estabelecimento;

			if (qt_protocolo_w = 0) then
				ie_status_w := 'PN';
			else
				PERFORM set_config('conciliar_integracao_ret_pck.nr_seq_protocolo_w', current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].nr_seq_protocolo, false);
			end if;
		else
			PERFORM set_config('conciliar_integracao_ret_pck.nr_seq_protocolo_w', coalesce(tiss_obter_seq_protocolo_xml(current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].cd_convenio,current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].nr_lote_prestador),0), false);
			if (current_setting('conciliar_integracao_ret_pck.nr_seq_protocolo_w')::imp_dem_retorno_prot.nr_seq_protocolo%type = 0) then
			
				PERFORM set_config('conciliar_integracao_ret_pck.nr_seq_protocolo_w', coalesce(tiss_obter_seq_protocolo_xml(current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].cd_convenio,current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].nr_protocolo_operadora),0), false);
			
				if (current_setting('conciliar_integracao_ret_pck.nr_seq_protocolo_w')::imp_dem_retorno_prot.nr_seq_protocolo%type = 0) then
					ie_status_w := 'PN';
				end if;

			end if;
		end if;

		current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].nr_seq_protocolo 	:= current_setting('conciliar_integracao_ret_pck.nr_seq_protocolo_w')::imp_dem_retorno_prot.nr_seq_protocolo%type;
		current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].ie_status 		:= ie_status_w;

		PERFORM set_config('conciliar_integracao_ret_pck.nr_seq_dem_ret_prot_w', current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].nr_sequencia, false);
		PERFORM set_config('conciliar_integracao_ret_pck.nr_seq_protocolo_w', current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].nr_seq_protocolo, false);

		j := 0;

		for cursor_contas_row in cursor_contas loop

			current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_interno_conta 	:= cursor_contas_row.nr_conta;
			current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_guia_operadora 	:= cursor_contas_row.nr_operadora;
			current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_guia_prestador 	:= cursor_contas_row.nr_guia_prest;
			current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).cd_senha 		:= cursor_contas_row.cd_senha;
			current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_seq_conta_guia 	:= cursor_contas_row.nr_seq_conta_guia;
			current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).vl_informado 		:= cursor_contas_row.vl_informado;			
			current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).cd_autorizacao	:= cursor_contas_row.cd_autorizacao;
			current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_sequencia		:= cursor_contas_row.nr_sequencia;
			current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).ie_status		:= cursor_contas_row.ie_status;
			j := j + 1;
		end loop;

		k := 0;
		for cursor_tiss_conta_guia_row in cursor_tiss_conta_guia loop
			current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).nr_interno_conta 		:= cursor_tiss_conta_guia_row.nr_interno_conta;
			current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).cd_autorizacao 		:= cursor_tiss_conta_guia_row.cd_autorizacao;
			current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).nr_guia_prestador 	:= cursor_tiss_conta_guia_row.nr_guia_prestador;
			current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).cd_senha 			:= cursor_tiss_conta_guia_row.cd_senha;
			current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).vl_total 			:= cursor_tiss_conta_guia_row.vl_total;
			current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).nr_sequencia 		:= cursor_tiss_conta_guia_row.nr_sequencia;
			current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).nr_seq_prot_tiss 		:= cursor_tiss_conta_guia_row.nr_seq_prot_tiss;
			k := k + 1;
		end loop;
		i := i + 1;
	end loop;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conciliar_integracao_ret_pck.popular_vetores () FROM PUBLIC;