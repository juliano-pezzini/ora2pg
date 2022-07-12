-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION permite_agendar_exame ( nr_seq_agenda_p bigint, cd_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_proc_interno_w		agenda_lista_espera.nr_seq_proc_interno%type;
cd_procedimento_w       		agenda_lista_espera.cd_procedimento%type;
ie_origem_proced_w      		agenda_lista_espera.ie_origem_proced%type;
cd_paciente_w	          		agenda_lista_espera.cd_pessoa_fisica%type;
cd_medico_exec_w  	    	agenda_lista_espera.cd_medico_exec%type;
cd_area_proced_w        		estrutura_procedimento_v.cd_area_procedimento%type;
cd_espec_proced_w       		estrutura_procedimento_v.cd_especialidade%type;
cd_grupo_proced_w       		estrutura_procedimento_v.cd_grupo_proc%type;
cd_estabelecimento_w    		estabelecimento.cd_estabelecimento%type;
ie_sexo_paciente_w      		pessoa_fisica.ie_sexo%type;
qtde_registros_w      		bigint := 0;


BEGIN

	cd_estabelecimento_w := coalesce(wheb_usuario_pck.get_cd_estabelecimento,1);

	SELECT	a.nr_seq_proc_interno,
		a.cd_procedimento,
		a.ie_origem_proced,
		a.CD_PESSOA_FISICA,
		a.CD_MEDICO_EXEC
	INTO STRICT	nr_seq_proc_interno_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		cd_paciente_w,
		cd_medico_exec_w
	FROM	agenda_lista_espera a
	WHERE	a.nr_sequencia = nr_seq_agenda_p
	ORDER BY CD_TIPO_AGENDA,
		nr_Seq_proc_interno,
		cd_medico,
		cd_Especialidade;

	SELECT	coalesce(MAX(cd_area_procedimento),0),
		coalesce(MAX(cd_especialidade),0),
		coalesce(MAX(cd_grupo_proc),0)
	INTO STRICT	cd_area_proced_w,
		cd_espec_proced_w,
		cd_grupo_proced_w
	FROM	estrutura_procedimento_v
	WHERE	cd_procedimento = cd_procedimento_w
	AND	ie_origem_proced = ie_origem_proced_w;

	SELECT	Obter_Sexo_PF(cd_paciente_w, 'C')
	INTO STRICT	ie_sexo_paciente_w
	;

  	select	count(nr_sequencia)
  	into STRICT	qtde_registros_w
  	from	agenda_regra
  	where	coalesce(cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
  	and	cd_agenda = cd_agenda_p;

  	IF (qtde_registros_w > 0) THEN
    		SELECT
      			COUNT(1)
    		INTO STRICT	qtde_registros_w
    		FROM	agenda_regra b,
      			agenda a
   		WHERE	a.cd_agenda = b.cd_agenda
    		AND	coalesce(a.ie_agenda_integrada,'N') = 'S'
		AND	a.ie_situacao = 'A'
		AND  	a.cd_tipo_agenda = 2
    		AND  	a.cd_agenda = cd_agenda_p
    		AND	((b.cd_area_proc = cd_area_proced_w) OR (coalesce(b.cd_area_proc::text, '') = ''))
    		AND	((b.cd_especialidade = cd_espec_proced_w) OR (coalesce(b.cd_especialidade::text, '') = ''))
    		AND	((b.cd_grupo_proc = cd_grupo_proced_w) OR (coalesce(b.cd_grupo_proc::text, '') = ''))
    		AND	((b.nr_seq_proc_interno = nr_seq_proc_interno_w) OR (coalesce(b.nr_seq_proc_interno::text, '') = ''))
    		AND	((b.cd_procedimento = cd_procedimento_w) OR (coalesce(b.cd_procedimento::text, '') = ''))
    		AND	((coalesce(b.cd_procedimento::text, '') = '') OR ((b.ie_origem_proced = ie_origem_proced_w) OR (coalesce(b.ie_origem_proced::text, '') = '')))
    		AND	((coalesce(a.cd_pessoa_fisica, cd_medico_exec_w) = cd_medico_exec_w) OR (coalesce(cd_medico_exec_w::text, '') = ''))
    		AND	coalesce(b.ie_situacao,'A') = 'A'
    		AND	((coalesce(a.ie_sexo_agenda,'A') = 'A') OR (ie_sexo_paciente_w = coalesce(a.ie_sexo_agenda,'A')));

    		IF (qtde_registros_w > 0) THEN
      			RETURN 'S';
    		ELSE
      			RETURN 'N';
    		END IF;
  	ELSE
    		return 'S';
  	END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION permite_agendar_exame ( nr_seq_agenda_p bigint, cd_agenda_p bigint) FROM PUBLIC;

