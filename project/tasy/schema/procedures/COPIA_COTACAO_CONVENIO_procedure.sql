-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copia_cotacao_convenio (CD_ESTAB_ORG_P bigint, CD_CONVENIO_ORG_P bigint, CD_MOEDA_ORG_P bigint, DT_REFERENCIA_ORG_P timestamp, IE_PREV_REAL_ORG_P text, CD_ESTAB_DST_P bigint, CD_CONVENIO_DST_P bigint, CD_MOEDA_DST_P bigint, DT_REFERENCIA_DST_P timestamp, IE_PREV_REAL_DST_P text, IE_VALOR_ZERADO_P text, VL_FILME_P bigint, NM_USUARIO_P text) AS $body$
DECLARE


NR_SEQUENCIA_W                    bigint;
CD_ESTABELECIMENTO_W              smallint;
CD_CONVENIO_W                     integer;
CD_MOEDA_W                        smallint;
IE_PREVISTO_REALIZADO_W           varchar(1);
DT_REFERENCIA_W                   timestamp;
VL_HONORARIOS_W                   double precision;
VL_CUSTO_OPER_W                   double precision;
VL_FILME_W                        double precision;
DT_ATUALIZACAO_W                  timestamp;
NM_USUARIO_W                      varchar(15);
CD_CATEGORIA_W                    varchar(10);
CD_AREA_PROCED_W                  bigint;
CD_ESPECIAL_PROCED_W              bigint;
CD_GRUPO_PROCED_W                 bigint;
CD_PROCEDIMENTO_W                 bigint;
IE_ORIGEM_PROCED_W                bigint;
CD_SETOR_ATENDIMENTO_W            integer;
IE_TIPO_ATENDIMENTO_W             smallint;
NR_SEQ_PROC_INTERNO_W		  bigint;
nr_seq_grupo_lab_w		bigint;
cd_tipo_acomodacao_w		smallint;


C001 CURSOR FOR
SELECT	VL_HONORARIOS,
		VL_CUSTO_OPER,
		VL_FILME,
		CD_CATEGORIA,
		CD_AREA_PROCED,
		CD_ESPECIAL_PROCED,
		CD_GRUPO_PROCED,
		CD_PROCEDIMENTO,
		IE_ORIGEM_PROCED,
		CD_SETOR_ATENDIMENTO,
		IE_TIPO_ATENDIMENTO,
		NR_SEQ_PROC_INTERNO,
		nr_seq_grupo_lab,
		cd_tipo_acomodacao
from		COTACAO_MOEDA_CONVENIO
WHERE		CD_ESTABELECIMENTO	= CD_ESTAB_ORG_P
AND		CD_CONVENIO			= CD_CONVENIO_ORG_P
AND		CD_MOEDA			= CD_MOEDA_ORG_P
AND		to_char(DT_REFERENCIA,'dd/mm/yyyy')
						= to_char(DT_REFERENCIA_ORG_P,'dd/mm/yyyy')
AND		IE_PREVISTO_REALIZADO	= IE_PREV_REAL_ORG_P
ORDER BY	NR_SEQUENCIA;


BEGIN

open 	c001;
loop
fetch c001 	into
		VL_HONORARIOS_W,
		VL_CUSTO_OPER_W,
		VL_FILME_W,
		CD_CATEGORIA_W,
		CD_AREA_PROCED_W,
		CD_ESPECIAL_PROCED_W,
		CD_GRUPO_PROCED_W,
		CD_PROCEDIMENTO_W,
		IE_ORIGEM_PROCED_W,
		CD_SETOR_ATENDIMENTO_W,
		IE_TIPO_ATENDIMENTO_W,
		NR_SEQ_PROC_INTERNO_W,
		nr_seq_grupo_lab_w,
		cd_tipo_acomodacao_w;
	EXIT WHEN NOT FOUND; /* apply on c001 */
		begin
		select nextval('cotacao_moeda_convenio_seq')
		into STRICT  nr_sequencia_w
		;

		if (cd_moeda_org_p 		<> cd_moeda_dst_p) or (ie_valor_zerado_p	= 'S') then
			begin
			VL_HONORARIOS_W		:= 0;
			VL_CUSTO_OPER_W		:= 0;
			end;
		end if;

		if (vl_filme_p			> 0) then
			vl_filme_w			:= vl_filme_p;
		end if;

		insert into cotacao_moeda_convenio(
				NR_SEQUENCIA,
				CD_ESTABELECIMENTO,
				CD_CONVENIO,
				CD_MOEDA,
				IE_PREVISTO_REALIZADO,
				DT_REFERENCIA,
				VL_HONORARIOS,
				VL_CUSTO_OPER,
				VL_FILME,
				DT_ATUALIZACAO,
				NM_USUARIO,
				CD_CATEGORIA,
				CD_AREA_PROCED,
				CD_ESPECIAL_PROCED,
				CD_GRUPO_PROCED,
				CD_PROCEDIMENTO,
				IE_ORIGEM_PROCED,
				CD_SETOR_ATENDIMENTO,
				IE_TIPO_ATENDIMENTO,
				IE_CREDENCIADO,
				IE_SITUACAO,
				NR_SEQ_PROC_INTERNO,
				nr_seq_grupo_lab,
				cd_tipo_acomodacao)
		values (
				NR_SEQUENCIA_W,
				CD_ESTAB_DST_P,
				CD_CONVENIO_DST_P,
				CD_MOEDA_DST_P,
				IE_PREV_REAL_DST_P,
				DT_REFERENCIA_DST_P,
				VL_HONORARIOS_W,
				VL_CUSTO_OPER_W,
				VL_FILME_W,
				clock_timestamp(),
				NM_USUARIO_P,
				CD_CATEGORIA_W,
				CD_AREA_PROCED_W,
				CD_ESPECIAL_PROCED_W,
				CD_GRUPO_PROCED_W,
				CD_PROCEDIMENTO_W,
				IE_ORIGEM_PROCED_W,
				CD_SETOR_ATENDIMENTO_W,
				IE_TIPO_ATENDIMENTO_W,
				'N',
				'A',
				NR_SEQ_PROC_INTERNO_W,
				nr_seq_grupo_lab_w,
				cd_tipo_acomodacao_w);
		end;
end loop;
close c001;
commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copia_cotacao_convenio (CD_ESTAB_ORG_P bigint, CD_CONVENIO_ORG_P bigint, CD_MOEDA_ORG_P bigint, DT_REFERENCIA_ORG_P timestamp, IE_PREV_REAL_ORG_P text, CD_ESTAB_DST_P bigint, CD_CONVENIO_DST_P bigint, CD_MOEDA_DST_P bigint, DT_REFERENCIA_DST_P timestamp, IE_PREV_REAL_DST_P text, IE_VALOR_ZERADO_P text, VL_FILME_P bigint, NM_USUARIO_P text) FROM PUBLIC;

