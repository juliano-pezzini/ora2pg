-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_novo_resumo_sum ( nr_seq_atend_sumario_p bigint) RETURNS text AS $body$
DECLARE

 
nr_ordem_w			integer;
nm_exame_w			varchar(255);
ds_evolucao_w			varchar(10000);
nr_exame_w			varchar(20);
dt_evolucao_w			timestamp;
ds_retorno_resumo_w		text;

C01 CURSOR FOR 
	SELECT	1 nr_ordem, 
		substr(Obter_desc_tipo_evolucao(ie_evolucao_clinica),1,200) nm_exame, 
		to_char(b.cd_evolucao) nr_exame 
	from	atend_sumario_alta_item a, 
		evolucao_paciente b 
	where	a.cd_evolucao = b.cd_evolucao 
	and	nr_seq_atend_sumario = nr_seq_atend_sumario_p 
	and	a.ie_tipo_item = 'V' 
	order by a.nr_sequencia desc;
	

BEGIN 
 
 
	 
open C01;
loop 
fetch C01 into 
	nr_ordem_w, 
	nm_exame_w, 
	nr_exame_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	--Monta_Texto_resumo(nm_exame_w,'',nr_ordem_w); 
	 
	/*select	max(dt_evolucao), 
		max(substr(obter_nome_pf(cd_medico),1,200)) 
	into	dt_evolucao_w, 
		nm_usuario_evol_w 
	from	evolucao_paciente 
	where	cd_evolucao = nr_exame_w; 
	*/
 
	--ds_dados_evol_w := ds_texto_inicio_w || wheb_mensagem_pck.get_texto(306727, 'DS_DATA=' || dt_evolucao_w) || '	' || wheb_mensagem_pck.get_texto(307014, null) || ' ' || nm_usuario_evol_w || ds_texto_fim_w; 
	 
	--Monta_Texto_resumo(ds_dados_evol_w,'N',nr_ordem_w); 
 
	select 	ds_evolucao 
	into STRICT	ds_evolucao_w 
	from 	evolucao_paciente 
	where 	cd_evolucao = nr_exame_w;
 
	ds_retorno_resumo_w := ds_retorno_resumo_w || ds_evolucao_w;
	 
	--Monta_Texto_resumo(ds_evolucao_w,'N',nr_ordem_w); 
	end;
end loop;
close C01;
	 
	 
return	ds_retorno_resumo_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_novo_resumo_sum ( nr_seq_atend_sumario_p bigint) FROM PUBLIC;
