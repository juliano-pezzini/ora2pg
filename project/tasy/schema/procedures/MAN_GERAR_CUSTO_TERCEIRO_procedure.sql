-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_gerar_custo_terceiro ( cd_estabelecimento_p bigint, nr_seq_ordem_serv_p bigint, nm_usuario_p text, dt_referencia_p timestamp) AS $body$
DECLARE

 
cd_centro_custo_w			integer;
cd_estabelecimento_w			smallint;
cd_setor_local_w			integer;
ds_centro_custo_w			varchar(80);
ds_setor_atendimento_w			varchar(100);
dt_fim_real_w				timestamp;
ie_status_ordem_w			varchar(1);
ie_tipo_w				varchar(15);
nr_grupo_trabalho_w			bigint;
nr_seq_localizacao_w			bigint;
nr_seq_nota_fiscal_w			bigint;
nr_seq_operacao_w			bigint;
nr_seq_terceiro_w			bigint;
nr_sequencia_w				bigint;
qt_registro_w				bigint;
vl_custo_w				double precision;

/* Custos da Ordem Serviço*/
 
c01 CURSOR FOR 
SELECT	a.ie_tipo, 
	coalesce(sum(a.vl_custo),0) 
from	man_ordem_serv_custo a 
where	a.nr_seq_ordem_serv = nr_seq_ordem_serv_p 
and	upper(a.ie_tipo) <> 'REQ' 
group by a.ie_tipo;


BEGIN 
 
/* Dados da ordem de serviço*/
 
select	dt_fim_real, 
	ie_status_ordem, 
	nr_seq_localizacao, 
	nr_grupo_trabalho 
into STRICT	dt_fim_real_w, 
	ie_status_ordem_w, 
	nr_seq_localizacao_w, 
	nr_grupo_trabalho_w 
from	man_ordem_servico 
where	nr_sequencia = nr_seq_ordem_serv_p;
 
/* Buscar os dados da localizacao */
 
select	cd_estabelecimento, 
	cd_setor 
into STRICT	cd_estabelecimento_w, 
	cd_setor_local_w 
from	man_localizacao 
where	nr_sequencia = nr_seq_localizacao_w;
 
/* Centro de Custo do setor da localização (Centro de Custo da Ordem de serviço) */
 
 
select	coalesce(max(cd_centro_custo),0), 
	Max(ds_setor_atendimento) 
into STRICT	cd_centro_custo_w, 
	ds_setor_atendimento_w 
from	setor_atendimento 
where	cd_setor_atendimento = cd_setor_local_w;
 
if (cd_centro_custo_w = 0) then 
	/*(-20011,'O setor da localização, ' || ds_setor_atendimento_w || chr(13) || ' não possui centro de custo informado!')*/
 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263074,'DS_SETOR=' || ds_setor_atendimento_w);
end if;
 
/* Pessoa Terceiro do centro custo - conta que receberá os valores da OS */
 
select	coalesce(max(nr_seq_terceiro),0), 
	max(ds_centro_custo) 
into STRICT	nr_seq_terceiro_w, 
	ds_centro_custo_w 
from	centro_custo 
where	cd_centro_custo = cd_centro_custo_w;
 
if (nr_seq_terceiro_w = 0) then 
	/*(-20011,'O centro de custo da localização, ' || ds_centro_custo_w || chr(13) || ' não possui terceiro informado!')*/
 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263075,'DS_CENTRO=' || ds_centro_custo_w);
end if;
/* Operação terceiro do grupo de trabalho*/
 
select	coalesce(max(nr_seq_operacao),0) 
into STRICT	nr_seq_operacao_w 
from	man_grupo_trabalho 
where	nr_sequencia = nr_grupo_trabalho_w 
and	cd_estabelecimento = cd_estabelecimento_p;
 
/* Buscar Valores de Custo da Ordem de Serviço - calcular*/
 
 
CALL man_calcular_custo_os(nr_seq_ordem_serv_p, nm_usuario_p);
 
/* Integrar na conta do terceiro somente se tiver Custo na OS */
 
select	count(*) 
into STRICT	qt_registro_w 
from	man_ordem_serv_custo 
where	nr_Seq_ordem_serv = nr_seq_ordem_serv_p;
 
if (dt_fim_real_w IS NOT NULL AND dt_fim_real_w::text <> '') and (ie_status_ordem_w = 3)	and (nr_seq_terceiro_w > 0) and (qt_registro_w > 0) 	then 
 
	open c01;
	loop 
	fetch c01 into 
		ie_tipo_w, 
		vl_custo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin	 
		select	nextval('terceiro_operacao_seq') 
		into STRICT	nr_sequencia_w 
		;
		insert into terceiro_operacao( 
			nr_sequencia, 
			cd_estabelecimento, 
			nr_seq_terceiro, 
			nr_seq_operacao, 
			tx_operacao, 
			dt_atualizacao, 
			nm_usuario, 
			nr_doc, 
			nr_seq_doc, 
			nr_seq_ordem_servico, 
			dt_operacao, 
			nr_seq_conta, 
			cd_material, 
			ie_origem_proced, 
			cd_procedimento, 
			qt_operacao, 
			vl_operacao) 
		values (nr_sequencia_w, 
			cd_estabelecimento_w, 
			nr_seq_terceiro_w, 
			nr_seq_operacao_w, 
			100, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_ordem_serv_p, 
			1, 
			nr_seq_ordem_serv_p, 
			dt_referencia_p, 
			null, 
 			null, 
			null, 
			null, 
			null, 
			vl_custo_w);
		CALL atualizar_operacao_terceiro(nr_sequencia_w, nm_usuario_p);
	end;
	end loop;
	close c01;
end if;
 
commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_gerar_custo_terceiro ( cd_estabelecimento_p bigint, nr_seq_ordem_serv_p bigint, nm_usuario_p text, dt_referencia_p timestamp) FROM PUBLIC;

