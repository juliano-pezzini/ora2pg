-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mprev_gerar_atend_resp ( nr_seq_partic_ciclo_item_p bigint, nr_seq_participante_p bigint, nr_seq_prog_partic_modulo_p bigint, nm_usuario_p text, ie_gerar_profi_prog_partic_p mprev_prog_partic_modulo.ie_gerar_profi_prog_partic%type default 'N') AS $body$
DECLARE


nr_seq_funcao_colab_w		mprev_funcao_colaborador.nr_sequencia%TYPE;
cd_profissional_w		pessoa_fisica.cd_pessoa_fisica%TYPE;
nr_seq_equipe_w			mprev_equipe.nr_sequencia%TYPE;
nr_seq_plano_atend_ir_resp_w	mprev_plano_atend_it_resp.nr_sequencia%TYPE;
nr_seq_plano_atend_item_w	mprev_plano_atendimento.nr_sequencia%TYPE;
nr_seq_classificacao_w		mprev_prog_partic_modulo.nr_seq_classificacao%TYPE;
nr_seq_modulo_w				mprev_programa_modulo.nr_seq_modulo%TYPE;
nr_seq_plano_atend_w			mprev_plano_atendimento.nr_sequencia%type;
ie_encontrou_w	varchar(1) := 'N';
ie_existe_igual_w bigint;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_funcao_colab,
		cd_profissional,
		nr_seq_equipe
	FROM	mprev_plano_atend_it_resp
	WHERE	nr_seq_plano_atend_item in (SELECT	b.nr_sequencia nr_seq_plano_atend_item
										from	mprev_plano_atend_item b,
												mprev_plano_atendimento c
										where 	b.nr_seq_plano_atend  = c.nr_sequencia
										and		c.nr_sequencia	= nr_seq_plano_atend_w);


BEGIN

select	max(a.nr_seq_classificacao), max(b.nr_seq_modulo)
into STRICT	nr_seq_classificacao_w, nr_seq_modulo_w	
from	mprev_prog_partic_modulo a,
    mprev_programa_modulo b,
    mprev_programa_partic c,
    mprev_modulo_atend d
where	a.nr_seq_programa_partic	= c.nr_sequencia
and	b.nr_sequencia			= a.nr_seq_prog_modulo
and	b.nr_seq_modulo			= d.nr_sequencia
and	c.nr_seq_participante		= nr_seq_participante_p
and	((a.nr_sequencia		= nr_seq_prog_partic_modulo_p) or (coalesce(nr_seq_prog_partic_modulo_p::text, '') = ''));


select	max(a.nr_sequencia)
into STRICT	nr_seq_plano_atend_w
from	mprev_plano_atendimento a
where	a.nr_seq_modulo	= nr_seq_modulo_w
and (a.nr_seq_classificacao = nr_seq_classificacao_w or coalesce(a.nr_seq_classificacao::text, '') = '')
and		ie_situacao = 'A';


OPEN c01;
LOOP
FETCH c01 INTO
	nr_seq_plano_atend_ir_resp_w,
	nr_seq_funcao_colab_w,
	cd_profissional_w,
	nr_seq_equipe_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	if (ie_gerar_profi_prog_partic_p = 'S') then
		SELECT 	MAX(d.nr_seq_equipe)
		INTO STRICT	nr_seq_equipe_w
		FROM   	mprev_partic_ciclo_atend a,
				mprev_partic_ciclo_item b,
				mprev_prog_partic_modulo c,
				mprev_prog_partic_prof d
		WHERE	b.nr_seq_partic_ciclo_atend = a.nr_sequencia
		AND		a.nr_seq_prog_partic_mod = c.nr_sequencia
		AND 	c.nr_seq_programa_partic = d.nr_seq_programa_partic
		AND 	b.nr_sequencia = nr_seq_partic_ciclo_item_p
		AND (coalesce(d.dt_fim_acomp::text, '') = '' or d.dt_fim_acomp > clock_timestamp());
	end if;

	select count(*)
	into STRICT ie_existe_igual_w
	from mprev_part_cic_item_resp a
	where (a.cd_profissional = cd_profissional_w or (coalesce(cd_profissional_w::text, '') = '' and coalesce(a.cd_profissional::text, '') = ''))
	and (a.nr_seq_funcao_colab = nr_seq_funcao_colab_w or (coalesce(nr_seq_funcao_colab_w::text, '') = '' and coalesce(a.nr_seq_funcao_colab::text, '') = ''))
	and (a.nr_seq_equipe = nr_seq_equipe_w or (coalesce(nr_seq_equipe_w::text, '') = '' and coalesce(a.nr_seq_equipe::text, '') = ''))
	and a.nr_seq_partic_ciclo_item = nr_seq_partic_ciclo_item_p;
	
	if (ie_existe_igual_w = 0) then
		INSERT INTO	mprev_part_cic_item_resp(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nr_seq_partic_ciclo_item,
				cd_profissional,
				nr_seq_funcao_colab,
				nr_seq_equipe)
		VALUES (nextval('mprev_part_cic_item_resp_seq'),
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_partic_ciclo_item_p,
				cd_profissional_w,
				nr_seq_funcao_colab_w,
				nr_seq_equipe_w);
	end if;

	ie_encontrou_w := 'S';
END LOOP;
CLOSE c01;

IF (ie_encontrou_w = 'N') THEN
	SELECT 	MAX(d.nr_seq_equipe),
			MAX(d.cd_profissional)
	INTO STRICT	nr_seq_equipe_w,
			cd_profissional_w
	FROM   	mprev_partic_ciclo_atend a,
			mprev_partic_ciclo_item b,
			mprev_prog_partic_modulo c,
			mprev_prog_partic_prof d
	WHERE	b.nr_seq_partic_ciclo_atend = a.nr_sequencia
	AND		a.nr_seq_prog_partic_mod = c.nr_sequencia
	AND 	c.nr_seq_programa_partic = d.nr_seq_programa_partic
	AND 	b.nr_sequencia = nr_seq_partic_ciclo_item_p;

	IF ((nr_seq_equipe_w IS NOT NULL AND nr_seq_equipe_w::text <> '') OR (cd_profissional_w IS NOT NULL AND cd_profissional_w::text <> '')) THEN
		INSERT INTO	mprev_part_cic_item_resp(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nr_seq_partic_ciclo_item,
				cd_profissional,
				nr_seq_equipe)
		VALUES (nextval('mprev_part_cic_item_resp_seq'),
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_partic_ciclo_item_p,
				cd_profissional_w,
				nr_seq_equipe_w);
	END IF;
END IF;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_gerar_atend_resp ( nr_seq_partic_ciclo_item_p bigint, nr_seq_participante_p bigint, nr_seq_prog_partic_modulo_p bigint, nm_usuario_p text, ie_gerar_profi_prog_partic_p mprev_prog_partic_modulo.ie_gerar_profi_prog_partic%type default 'N') FROM PUBLIC;

