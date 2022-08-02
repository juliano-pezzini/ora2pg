-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proc_participante_beforepost ( cd_funcao_p text, dt_conta_p timestamp, ie_origem_proced_p bigint, cd_procedimento_p bigint, cd_edicao_amb_p bigint, cd_categoria_p bigint, cd_convenio_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

			 
ie_anestesista_w	 varchar(1);
ds_porte_w		 varchar(5);
ie_consiste_anest_port_w varchar(1);


BEGIN 
--Utilizado na Gestão de exames Java 
 
select 	max(ie_consiste_anest_porte) 
into STRICT	ie_consiste_anest_port_w 
from 	parametro_faturamento 
where 	cd_estabelecimento = cd_estabelecimento_p;
 
if (ie_consiste_anest_port_w = 'S') then 
 
	select 	max(ie_anestesista) 
	into STRICT	ie_anestesista_w 
	from 	funcao_medico 
	where 	cd_funcao = cd_funcao_p;
 
	ds_porte_w := obter_dados_preco_proc(cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, cd_edicao_amb_p, cd_procedimento_p, ie_origem_proced_p, dt_conta_p, 'P');
 
	if (ie_anestesista_w = 'S') and (ds_porte_w = '0') then 
		/*Não é permitido o lançamento de anestesistas para procedimentos sem porte anestésico. Verifique os parâmetros do faturamento.'||'#@#@');*/
 
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(261478);
	end if;
 
elsif (ie_consiste_anest_port_w = 'P') then 
	 
	select 	max(ie_anestesista) 
	into STRICT	ie_anestesista_w 
	from 	funcao_medico 
	where 	cd_funcao = cd_funcao_p;
 
	ds_porte_w := obter_dados_preco_proc(cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, cd_edicao_amb_p, cd_procedimento_p, ie_origem_proced_p, dt_conta_p, 'PN');
 
	if (ie_anestesista_w = 'S') and (ds_porte_w = '0') then 
		/*Não é permitido o lançamento de anestesistas para procedimentos sem porte anestésico. Verifique os parâmetros do faturamento.'||'#@#@');*/
 
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(261478);
	end if;
 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proc_participante_beforepost ( cd_funcao_p text, dt_conta_p timestamp, ie_origem_proced_p bigint, cd_procedimento_p bigint, cd_edicao_amb_p bigint, cd_categoria_p bigint, cd_convenio_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

