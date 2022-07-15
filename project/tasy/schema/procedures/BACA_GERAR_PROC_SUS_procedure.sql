-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_gerar_proc_sus () AS $body$
DECLARE


DT_ATUALIZACAO_W			timestamp;
NM_USUARIO_W			varchar(15);
cd_procedimento_w			bigint;
qt_procedimento_w			bigint;
dt_competencia_w			timestamp;

C01 CURSOR FOR
SELECT 	dt_competencia
from		sus_preco_procaih
where		cd_procedimento 	= 99080010;



BEGIN
/* drop constraints */

/* alter table procedimento drop constraint SYS_C008397; */

/* Incluir procedimento 99080011-Diaria de acompanhante especial */

cd_procedimento_w			:= 0;
begin
select 	cd_procedimento
into STRICT		cd_procedimento_w
from		procedimento
where		cd_procedimento 	= 99080011
and		ie_origem_proced	= 2;
exception
		when others then
		cd_procedimento_w := 0;
end;

if (cd_procedimento_w = 0) then
	begin
	insert into procedimento(
			CD_PROCEDIMENTO,
			DS_PROCEDIMENTO,
			DS_COMPLEMENTO,
			IE_SITUACAO,
			CD_GRUPO_PROC,
			DT_ATUALIZACAO,
			NM_USUARIO,
			CD_TIPO_PROCEDIMENTO,
			IE_CLASSIFICACAO,
			CD_LAUDO_PADRAO,
			CD_SETOR_EXCLUSIVO,
			IE_ORIGEM_PROCED,
			QT_DIA_INTERNACAO_SUS,
			QT_IDADE_MINIMA_SUS,
			QT_IDADE_MAXIMA_SUS,
			IE_SEXO_SUS,
			IE_INREAL_SUS,
			IE_INATOM_SUS,
			CD_GRUPO_SUS,
			CD_DOENCA_CID,
			CD_CID_SECUNDARIO,
			DS_PROC_INTERNO,
			NR_PROC_INTERNO,
			IE_UTIL_PRESCRICAO,
			CD_KIT_MATERIAL,
			DS_ORIENTACAO,
			IE_VALOR_ESPECIAL,
			DT_CARGA,
			QT_MAX_PROCEDIMENTO,
			IE_EXIGE_LAUDO,
			IE_FORMA_APRESENTACAO)
	SELECT
			99080011,
			'DIARIA ACOMPANHANTE ESPECIAL',
			null,
			'S',
			x.CD_GRUPO_PROC,
			clock_timestamp(),
			'Tasy',
			x.CD_TIPO_PROCEDIMENTO,
			x.IE_CLASSIFICACAO,
			x.CD_LAUDO_PADRAO,
			x.CD_SETOR_EXCLUSIVO,
			x.IE_ORIGEM_PROCED,
			x.QT_DIA_INTERNACAO_SUS,
			0,
			99,
			x.IE_SEXO_SUS,
			x.IE_INREAL_SUS,
			x.IE_INATOM_SUS,
			x.CD_GRUPO_SUS,
			x.CD_DOENCA_CID,
			x.CD_CID_SECUNDARIO,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			x.QT_MAX_PROCEDIMENTO,
			x.IE_EXIGE_LAUDO,
			x.IE_FORMA_APRESENTACAO
		from	procedimento x
		where	x.cd_procedimento 	= 99080010
		and	x.ie_origem_proced	= 2;
	commit;
	end;
end if;


/* Incluir procedimento 99080011 na sus_preco_procaih */

open c01;
loop
	fetch 	c01 into
			dt_competencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
			BEGIN
			qt_procedimento_w			:= 0;
			begin
			select 	count(*)
			into STRICT		qt_procedimento_w
			from		sus_preco_procaih
			where		cd_procedimento 	= 99080011
			and		dt_competencia	= dt_competencia_w;
			exception
					when others then
					qt_procedimento_w	:= 0;
			end;

			if (qt_procedimento_w	= 0) then
				begin
				insert into	sus_preco_procaih(DT_COMPETENCIA,
							CD_PROCEDIMENTO,
							IE_ORIGEM_PROCED,
							DT_COMPETENCIA_INICIAL,
							DT_COMPETENCIA_FINAL,
							QT_IDADE_MINIMA,
							QT_IDADE_MAXIMA,
							IE_SEXO_SUS,
							IE_INREAL,
							IE_INATOM,
							QT_PERMANENCIA,
							QT_ATO_MEDICO,
							QT_ATO_ANESTESISTA,
							VL_MATMED,
							VL_DIARIA,
							VL_TAXAS,
							VL_MEDICO,
							VL_SADT,
							DT_ATUALIZACAO,
							NM_USUARIO,
							IE_VERSAO)
				SELECT
							x.DT_COMPETENCIA,
							99080011,
							x.IE_ORIGEM_PROCED,
							x.DT_COMPETENCIA_INICIAL,
							x.DT_COMPETENCIA_FINAL,
							0,
							99,
							x.IE_SEXO_SUS,
							x.IE_INREAL,
							x.IE_INATOM,
							0,
							0,
							0,
							2.65,
							0,
							0,
							0,
							0,
							clock_timestamp(),
							'Tasy',
							x.IE_VERSAO
				from			sus_preco_procaih x
				where			x.cd_procedimento = 99080010
				and			x.dt_competencia	= dt_competencia_w;
				end;
			end if;

			END;
END LOOP;
close c01;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_gerar_proc_sus () FROM PUBLIC;

