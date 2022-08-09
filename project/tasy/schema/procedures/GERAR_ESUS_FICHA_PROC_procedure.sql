-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_esus_ficha_proc (nm_usuario_p text) AS $body$
DECLARE


esus_ficha_proc_profis_w ESUS_FICHA_PROC_PROFIS%rowtype;

nr_seq_equipe_sus_w sus_profissional_equipe.nr_seq_equipe_sus%type;
cd_municipio_equipe_w sus_profissional_equipe.cd_municipio_equipe%type;
ds_erro_w varchar(4000);

C01 CURSOR FOR
SELECT a.CD_MEDICO, OBTER_ESTAB_ATEND(a.NR_ATENDIMENTO) CD_ESTABELECIMENTO
from ATEND_CONSULTA_PEPA a
where coalesce(a.DT_INATIVACAO::text, '') = ''
  and (a.DT_LIBERACAO IS NOT NULL AND a.DT_LIBERACAO::text <> '')
  and trunc(a.DT_LIBERACAO) = trunc(clock_timestamp())
  and a.CD_MEDICO not in (select b.CD_PROFISSIONAL
    from ESUS_FICHA_PROC_PROFIS b
    where b.CD_PROFISSIONAL = a.CD_MEDICO
      and trunc(b.DT_ATENDIMENTO) = trunc(clock_timestamp())
      and b.CD_ESTABELECIMENTO = coalesce(OBTER_ESTAB_ATEND(a.NR_ATENDIMENTO), OBTER_ESTABELECIMENTO_ATIVO))
group by CD_MEDICO, NR_ATENDIMENTO;

BEGIN

for consultas in C01 loop
	if ((coalesce(consultas.CD_ESTABELECIMENTO,OBTER_ESTABELECIMENTO_ATIVO) IS NOT NULL AND (coalesce(consultas.CD_ESTABELECIMENTO,OBTER_ESTABELECIMENTO_ATIVO))::text <> '')) then
		esus_ficha_proc_profis_w := null;
		esus_ficha_proc_profis_w.CD_PROFISSIONAL := consultas.CD_MEDICO;
		esus_ficha_proc_profis_w.DT_ATUALIZACAO := clock_timestamp();
		esus_ficha_proc_profis_w.NM_USUARIO := nm_usuario_p;
		esus_ficha_proc_profis_w.DT_ATUALIZACAO_NREC := clock_timestamp();
		esus_ficha_proc_profis_w.DT_LIBERACAO := clock_timestamp();
		esus_ficha_proc_profis_w.NM_USUARIO_NREC := nm_usuario_p;
		esus_ficha_proc_profis_w.DT_ATENDIMENTO := clock_timestamp();
		esus_ficha_proc_profis_w.CD_ESTABELECIMENTO := coalesce(consultas.CD_ESTABELECIMENTO,OBTER_ESTABELECIMENTO_ATIVO);

		select nextval('esus_ficha_proc_profis_seq')
		into STRICT esus_ficha_proc_profis_w.nr_sequencia
		;

    SELECT * FROM esus_obter_dados_prof(
      cd_profissional_p     => esus_ficha_proc_profis_w.CD_PROFISSIONAL, nr_seq_equipe_sus_p   => nr_seq_equipe_sus_w, cd_cbo_p              => esus_ficha_proc_profis_w.CD_CBO, cd_municipio_equipe_p	=> cd_municipio_equipe_w, nr_cnes_equipe_p      => esus_ficha_proc_profis_w.CD_CNES_UNIDADE, nr_seq_equipe_p       => esus_ficha_proc_profis_w.NR_SEQ_SUS_EQUIPE, ds_erro_p             => ds_erro_w) INTO STRICT nr_seq_equipe_sus_p   => nr_seq_equipe_sus_w, cd_cbo_p              => esus_ficha_proc_profis_w.CD_CBO, cd_municipio_equipe_p	=> cd_municipio_equipe_w, nr_cnes_equipe_p      => esus_ficha_proc_profis_w.CD_CNES_UNIDADE, nr_seq_equipe_p       => esus_ficha_proc_profis_w.NR_SEQ_SUS_EQUIPE, ds_erro_p             => ds_erro_w;

		insert into ESUS_FICHA_PROC_PROFIS values (esus_ficha_proc_profis_w.*);
		
		CALL ESUS_GERAR_PACIENTE_PROF(
			CD_PROFISSIONAL_P => esus_ficha_proc_profis_w.CD_PROFISSIONAL,
			CD_CBO_P => esus_ficha_proc_profis_w.CD_CBO,
			DT_ATENDIMENTO_P => esus_ficha_proc_profis_w.DT_ATENDIMENTO,
			CD_ESTABELECIMENTO_P => esus_ficha_proc_profis_w.CD_ESTABELECIMENTO,
			IE_LOCAL_ATENDIMENTO_P => esus_ficha_proc_profis_w.IE_LOCAL_ATENDIMENTO,
			NR_SEQ_FICHA_PRO_PROF_P => esus_ficha_proc_profis_w.nr_sequencia,
			NM_USUARIO_P => esus_ficha_proc_profis_w.NM_USUARIO
		);

    commit;
	end if;
end loop;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_esus_ficha_proc (nm_usuario_p text) FROM PUBLIC;
