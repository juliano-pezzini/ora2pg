-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tuss_carga_proc_completa ( cd_proc_p bigint, ds_proc_p text, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


qt_registros_w	bigint;
qt_reg_proced_w	bigint;
qt_reg_estrut_w	bigint;
ds_erro_w	varchar(2000);
nr_sequencia_w	bigint;
cd_grupo_w	bigint;


BEGIN

qt_registros_w		:= 0;
ds_erro_w		:= 'OK';
cd_grupo_w		:= somente_numero('8' || substr(cd_proc_p,1,1) || substr(cd_proc_p,1,5));

/* Carga do procedimento */

begin
select 	count(*)
into STRICT	qt_registros_w
from	procedimento
where	cd_procedimento	= cd_proc_p
and	ie_origem_proced = 8;

select	count(*)
into STRICT	qt_reg_estrut_w
from	grupo_proc
where	cd_grupo_proc = cd_grupo_w;


if (qt_registros_w	= 0) and (qt_reg_estrut_w <> 0) then
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
			IE_FORMA_APRESENTACAO,
			IE_APURACAO_CUSTO,
			QT_HORA_BAIXAR_PRESCR,
			NR_SEQ_GRUPO_REC,
			DS_PRESCRICAO,
			IE_EXIGE_AUTOR_SUS,
			QT_EXEC_BARRA,
			DS_PROCEDIMENTO_PESQUISA,
			IE_ATIV_PROF_BPA,
			IE_ALTA_COMPLEXIDADE,
			IE_IGNORA_ORIGEM,
			IE_CLASSIF_CUSTO,
			ie_localizador)
	values (cd_proc_p,
			InitCap(substr(ds_proc_p,1,240)),
			null,
			'A',
			cd_grupo_w,
			clock_timestamp(),
			nm_usuario_p,
			 null,
			 '1',
			 null,
			 null,
			 8,
			 null,
			 null,
			 null,
			 null,
			 null,
			 null,
			 null,
			 null,
			 null,
			 InitCap(substr(ds_proc_p,1,80)),
			 cd_proc_p,
			 null,
			 null,
			 null,
			 null,
			 null,
			 null,
			 null,
			 null,
			 null,
			 null,
			 null,
			 null,
			 'N',
			 1,
			 null,
			'N',
			'N',
			'N',
			'B',
			'S');
	exception
  	when others then
    		ds_erro_w	:= SQLERRM(SQLSTATE);
    		/*insert into logxxxxxx_tasy values(sysdate, 'TUSS', 80,
			 'Erro insert proc : ' || to_char(cd_grupo_w) || ds_erro_w);*/
	end;
end if;
end;

commit;
ds_erro_p	:= ds_erro_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tuss_carga_proc_completa ( cd_proc_p bigint, ds_proc_p text, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

