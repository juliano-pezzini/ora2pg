-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_inserir_proced_conta ( nr_atendimento_p bigint, ie_forma_geracao_p text, nm_usuario_p text, cd_setor_atendimento_p bigint, ie_tipo_dialise_p text ) AS $body$
DECLARE

cd_procedimento_w      bigint := 0;
ie_origem_proced_w     smallint  := NULL;
nr_seq_proc_pac_w      bigint := 0;
nr_atendimento_w       bigint := 0;
nr_seq_atepacu_w       bigint := 0;
nr_seq_proc_interno_w  bigint := 0;
cd_convenio_w          bigint := 0;
cd_categoria_w         bigint := 0;
cd_pessoa_fisica_w     bigint := 0;
dt_ent_unidade_w       timestamp         := clock_timestamp();
cd_local_estoque_w     bigint;
ds_erro_w              varchar(255);
qt_registros_w         bigint;
cd_doenca_cid_w        varchar(10);
ie_gerar_w             varchar(1);
qt_cid_w               bigint;
cd_estabelecimento_w   bigint;
cd_profissional_w      varchar(10);
ie_tipo_atendimento_w  smallint;
ie_medico_executor_w   varchar(10);
cd_medico_executor_w   varchar(10);
cd_cgc_prest_regra_w   varchar(14);
cd_pes_fis_regra_w     varchar(10);
nr_seq_classificacao_w bigint;
cd_medico_exec_w       varchar(10);
cd_medico_laudo_sus_w  varchar(10);
ie_tipo_convenio_w     smallint;
ie_paciente_agudo_w    varchar(1);
nr_prescricao_w        bigint;
ie_tipo_hemodialise_w  varchar(15);
nr_seq_queixa_regra_w queixa_paciente.nr_sequencia%type;
nr_seq_queixa_atend_w queixa_paciente.nr_sequencia%type;


C01 CURSOR FOR
SELECT a.cd_procedimento,
	a.ie_origem_proced,
	a.nr_seq_proc_interno,
	a.cd_doenca_cid,
	a.nr_seq_queixa
FROM hd_gerar_proced_conta a
WHERE upper(a.ie_forma_geracao) = upper(ie_forma_geracao_p)
AND   upper(a.ie_situacao)        = upper('A')
AND  ((ie_tipo_dialise = ie_tipo_dialise_p) OR (coalesce(ie_tipo_dialise::text, '') = ''))
AND  ((ie_tipo_hemodialise  = ie_tipo_hemodialise_w) OR (coalesce(ie_tipo_hemodialise::text, '') = ''))
AND  ((ie_tipo_convenio = ie_tipo_convenio_w) OR (coalesce(ie_tipo_convenio::text, '') = ''))
AND ((ie_tipo_atendimento = ie_tipo_atendimento_w) OR (coalesce(ie_tipo_atendimento::text, '') = ''))
AND  ((cd_convenio = cd_convenio_w) OR (coalesce(cd_convenio::text, '') = ''))
AND ((coalesce(a.ie_tipo,'A') = ie_paciente_agudo_w) OR (coalesce(a.ie_tipo,'A') = 'A'))
AND (ie_tratamento IN (SELECT x.ie_tratamento
		       FROM paciente_tratamento x
		       WHERE x.cd_pessoa_fisica           = cd_pessoa_fisica_w
		       AND TRUNC(x.DT_INICIO_TRATAMENTO) <= TRUNC(clock_timestamp())
		       AND (coalesce(x.DT_FINAL_TRATAMENTO::text, '') = ''
		       OR x.DT_FINAL_TRATAMENTO          >= TRUNC(clock_timestamp()))) OR (coalesce(ie_tratamento::text, '') = ''))
AND (nr_seq_classificacao IN (SELECT x.NR_SEQ_CLASSIFICACAO
			      FROM HD_PACIENTE_CLASSIF_SOR x
			      WHERE x.cd_pessoa_fisica = cd_pessoa_fisica_w
			      AND (TRUNC(x.DT_INICIO) <= TRUNC(clock_timestamp())
			      OR coalesce(x.DT_INICIO::text, '') = '')
			      AND (coalesce(x.DT_FIM::text, '') = ''
			      OR x.DT_FIM             >= TRUNC(clock_timestamp()))) OR (ie_sem_classificacao = 'S'
									  AND NOT EXISTS (SELECT x.NR_SEQ_CLASSIFICACAO
											  FROM HD_PACIENTE_CLASSIF_SOR x
										          WHERE x.cd_pessoa_fisica = cd_pessoa_fisica_w
										          AND (TRUNC(x.DT_INICIO) <= TRUNC(clock_timestamp())
										          OR coalesce(x.DT_INICIO::text, '') = '')
										          AND (coalesce(x.DT_FIM::text, '') = ''
										          OR x.DT_FIM             >= TRUNC(clock_timestamp()))))
									  OR (coalesce(nr_seq_classificacao::text, '') = ''
								          AND ie_sem_classificacao  = 'N'))
AND (coalesce(a.ie_necessita_vaga_esp,'N') = coalesce((select max(s.ie_necessita_vaga_esp)
					     from hd_paciente_classif_sor c,
						  hd_classificacao_sorologia s
					    where c.cd_pessoa_fisica = cd_pessoa_fisica_w
					    and c.nr_seq_classificacao = s.nr_sequencia
					    and (trunc(c.dt_inicio) <= trunc(clock_timestamp()) or coalesce(c.dt_inicio::text, '') = '')
					    and (coalesce(c.dt_fim::text, '') = '' or c.dt_fim >= trunc(clock_timestamp()))),'N') or coalesce(a.ie_necessita_vaga_esp,'N') = 'N');
					

BEGIN

SELECT coalesce(COUNT(*),'0') 
INTO STRICT qt_registros_w 
FROM hd_gerar_proced_conta;


IF ((qt_registros_w > 0) AND (nr_atendimento_p <> '0') AND (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '')) THEN
     BEGIN
     SELECT MAX(obter_convenio_atendimento(a.nr_atendimento)),
	MAX(obter_dados_categ_conv(a.nr_atendimento,'CA')),
	MAX(a.cd_pessoa_fisica),
	MAX(cd_estabelecimento),
	MAX(ie_tipo_atendimento),
	MAX(nr_seq_classificacao),
	MAX(Obter_Tipo_Convenio(obter_convenio_atendimento(a.nr_atendimento))),
	MAX(nr_seq_queixa)
     INTO STRICT cd_convenio_w,
	  cd_categoria_w,
	  cd_pessoa_fisica_w,
	  cd_estabelecimento_w,
	  ie_tipo_atendimento_w,
	  nr_seq_classificacao_w,
	  ie_tipo_convenio_w,
	  nr_seq_queixa_atend_w
     FROM atendimento_paciente a
     WHERE a.nr_atendimento = nr_atendimento_p;

     SELECT coalesce(MAX(ie_paciente_agudo),'N')
     INTO STRICT ie_paciente_agudo_w
     FROM paciente_tratamento
     WHERE nr_sequencia = (SELECT MAX(nr_sequencia)
			   FROM paciente_tratamento a
			   WHERE a.cd_pessoa_fisica = cd_pessoa_fisica_w
			   AND coalesce(dt_final_tratamento::text, '') = '');
			

     -- NR_SEQ_ATEPACU -- obtem data entrada unidade do atendimento quando setor for igual ao do usuario no momento da dialise
     SELECT MAX(w.dt_entrada_unidade)
     INTO STRICT dt_ent_unidade_w
     FROM atend_paciente_unidade w
     WHERE w.nr_atendimento     = nr_atendimento_p
     AND w.cd_setor_atendimento = cd_setor_atendimento_p;

     BEGIN
       SELECT MAX(a.nr_seq_interno)
       INTO STRICT nr_seq_atepacu_w
       FROM atend_paciente_unidade a
       WHERE a.cd_setor_atendimento    = cd_setor_atendimento_p
       AND a.nr_atendimento            = nr_atendimento_p
       AND TRUNC(a.dt_entrada_unidade) = TRUNC(dt_ent_unidade_w);
     EXCEPTION
     WHEN OTHERS THEN
	nr_seq_atepacu_w := 0;
     END;

     IF coalesce(dt_ent_unidade_w::text, '') = '' THEN
        dt_ent_unidade_w  := clock_timestamp(); --data entrada unidade, se tiver null eh pq nao teve passagem, atribui sysdate neste caso.
     END IF;

     --Se não possuir passagem naquele setor / atendimento, é preciso gerar passagem, se precisar gerar passagem  e não possuir NR_ATENDIMENTO, não será possivel gerar passagem,

     --neste caso a procedure vai ter q abortar
     IF ((nr_atendimento_p = '0') OR (coalesce(nr_atendimento_p::text, '') = '')) THEN
	  ds_erro_w          := wheb_mensagem_pck.get_texto(793796)||chr(13);
	  CALL Wheb_mensagem_pck.exibir_mensagem_abort(191445);
     END IF;

     --se nao achar passagem setor, gera passagem.
     IF (coalesce(nr_seq_atepacu_w,0) = 0) THEN
	  CALL gerar_passagem_setor_atend( nr_atendimento_p, cd_setor_atendimento_p, clock_timestamp(),--dt_ent_unidade_w,
	  'S', nm_usuario_p);
     END IF;

     SELECT MAX(a.nr_seq_interno)
     INTO STRICT nr_seq_atepacu_w
     FROM atend_paciente_unidade a
     WHERE a.cd_setor_atendimento    = cd_setor_atendimento_p
     AND a.nr_atendimento            = nr_atendimento_p
     AND TRUNC(a.dt_entrada_unidade) = TRUNC(dt_ent_unidade_w);


     SELECT MAX(cd_local_estoque)
     INTO STRICT cd_local_estoque_w
     FROM setor_atendimento
     WHERE cd_setor_atendimento = cd_setor_atendimento_p;

     SELECT MAX(a.nr_prescricao)
     INTO STRICT nr_prescricao_w
     FROM prescr_medica a,
	hd_prescricao b
     WHERE a.nr_prescricao = b.nr_prescricao
     AND a.ie_hemodialise  = 'S'
     AND a.cd_pessoa_fisica = cd_pessoa_fisica_w
     AND a.nr_atendimento = nr_atendimento_p
     AND coalesce(a.dt_suspensao::text, '') = ''
     AND (coalesce(a.dt_liberacao_medico, a.dt_liberacao) IS NOT NULL AND (coalesce(a.dt_liberacao_medico, a.dt_liberacao))::text <> '')
     AND coalesce(a.dt_fim_prescricao::text, '') = '';

     SELECT MAX(IE_TIPO_HEMODIALISE)
     INTO STRICT ie_tipo_hemodialise_w
     FROM prescr_medica a,
	hd_prescricao b
     WHERE a.nr_prescricao = b.nr_prescricao
     AND a.ie_hemodialise = 'S'
     AND a.nr_prescricao = nr_prescricao_w
     AND (coalesce(a.dt_liberacao_medico, a.dt_liberacao) IS NOT NULL AND (coalesce(a.dt_liberacao_medico, a.dt_liberacao))::text <> '')
     AND coalesce(a.dt_fim_prescricao::text, '') = '';

     OPEN c01;
     LOOP
        FETCH c01
        INTO cd_procedimento_w,
	 ie_origem_proced_w,
	 nr_seq_proc_interno_w,
	 cd_doenca_cid_w,
	 nr_seq_queixa_regra_w;
        EXIT WHEN NOT FOUND; /* apply on c01 */

	IF (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') AND (coalesce(cd_procedimento_w::text, '') = '') THEN
	    SELECT * FROM obter_proc_tab_interno_conv(nr_seq_proc_interno_w, cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, NULL, cd_setor_atendimento_p, cd_procedimento_w, ie_origem_proced_w, NULL, clock_timestamp(), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
	END IF;

	ie_gerar_w          := 'S';

	IF (cd_doenca_cid_w IS NOT NULL AND cd_doenca_cid_w::text <> '') THEN
	    SELECT COUNT(*)
	    INTO STRICT qt_cid_w
	    FROM diagnostico_doenca a,
		atendimento_paciente b
	    WHERE a.nr_atendimento = b.nr_atendimento
	    AND cd_doenca          = cd_doenca_cid_w
	    AND b.cd_pessoa_fisica = cd_pessoa_fisica_w;
	
	    ie_gerar_w            := 'N';

	    IF (qt_cid_w           > 0) THEN
		ie_gerar_w          := 'S';
	    END IF;
	END IF;

	/*Verifica se o motivo do atendimento do paciente é o mesmo cadastrado na regra
	Aplicação Principal > Regra de geração de procedimento > Hemodiálise campo 'Motivo Atendimento'
	Caso existir e for diferênte do atendimento não lançar na conta. OS 1013657*/
  
	IF (ie_gerar_w = 'S') THEN
	    IF (nr_seq_queixa_regra_w IS NOT NULL AND nr_seq_queixa_regra_w::text <> '') THEN
		IF (nr_seq_queixa_regra_w <> coalesce(nr_seq_queixa_atend_w,0)) THEN
		    ie_gerar_w := 'N';
		END IF;
	    END IF;
	END IF;

	SELECT MAX(coalesce(cd_pessoa_fisica,cd_profissional_w))
	INTO STRICT cd_profissional_w
	FROM usuario
	WHERE nm_usuario = nm_usuario_p;

	/*Início - Geliard OS408308 */

	SELECT * FROM consiste_medico_executor(cd_estabelecimento_w, cd_convenio_w, cd_setor_atendimento_p, cd_procedimento_w, ie_origem_proced_w, ie_tipo_atendimento_w, NULL, nr_seq_proc_interno_w, ie_medico_executor_w, cd_cgc_prest_regra_w, cd_medico_executor_w, cd_pes_fis_regra_w, NULL, clock_timestamp(), nr_seq_classificacao_w, 'N', NULL, NULL) INTO STRICT ie_medico_executor_w, cd_cgc_prest_regra_w, cd_medico_executor_w, cd_pes_fis_regra_w;
	IF (cd_medico_executor_w IS NOT NULL AND cd_medico_executor_w::text <> '') AND (coalesce(cd_medico_exec_w::text, '') = '') THEN
	    cd_medico_exec_w := cd_medico_executor_w;
	END IF;

	IF (coalesce(cd_medico_executor_w::text, '') = '') AND (ie_medico_executor_w = 'N') THEN
	    cd_medico_exec_w := NULL;
	END IF;

	IF (ie_medico_executor_w = 'S') THEN
	    SELECT MAX(cd_medico_requisitante)
	    INTO STRICT cd_medico_laudo_sus_w
	    FROM sus_laudo_paciente
            WHERE nr_atendimento      = nr_atendimento_p
            AND cd_procedimento_solic = cd_procedimento_w
            AND ie_origem_proced      = ie_origem_proced_w;

	    cd_medico_exec_w         := coalesce(cd_medico_laudo_sus_w,cd_medico_exec_w);
	END IF;

	IF (ie_medico_executor_w = 'M') THEN
	    BEGIN
	    cd_medico_laudo_sus_w := sus_obter_dados_sismama_atend(nr_atendimento_p,'M','CMR');
	    cd_medico_exec_w      := coalesce(cd_medico_laudo_sus_w,cd_medico_exec_w);
	    END;
	END IF;

	IF (ie_medico_executor_w = 'A') AND (coalesce(cd_medico_exec_w::text, '') = '') THEN
	    SELECT MAX(cd_medico_resp)
	    INTO STRICT cd_medico_exec_w
	    FROM atendimento_paciente
	    WHERE nr_atendimento = nr_atendimento_p;
	END IF;

	IF (ie_medico_executor_w = 'F') AND (cd_medico_executor_w IS NOT NULL AND cd_medico_executor_w::text <> '') THEN
	   cd_medico_exec_w      := cd_medico_executor_w;
	END IF;

	IF (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') OR (cd_profissional_w IS NOT NULL AND cd_profissional_w::text <> '') AND (ie_medico_executor_w = 'Y') THEN
	    cd_pes_fis_regra_w   := NULL;
	    cd_profissional_w    := NULL;
	END IF;

	/*Final - Geliard OS408308 */

	IF (ie_gerar_w = 'S') THEN
	    SELECT nextval('procedimento_paciente_seq') 
	    INTO STRICT nr_seq_proc_pac_w 
	;

	    INSERT INTO procedimento_paciente(
		nr_sequencia,
		nr_atendimento,
		dt_entrada_unidade,
		cd_procedimento,
		dt_procedimento,
		qt_procedimento,
		dt_atualizacao,
		nm_usuario,
		cd_setor_atendimento,
		ie_origem_proced,
		nr_seq_atepacu,
		nr_seq_proc_interno,
		cd_convenio,
		cd_categoria,
		cd_pessoa_fisica,
		cd_medico_executor,
		cd_cgc_prestador
	    ) VALUES (
		nr_seq_proc_pac_w,
		nr_atendimento_p,
		dt_ent_unidade_w,
		cd_procedimento_w,
		clock_timestamp(),
		1,
		clock_timestamp(),
		nm_usuario_p,
		cd_setor_atendimento_p,
		ie_origem_proced_w,
		nr_seq_atepacu_w,
		nr_seq_proc_interno_w,
		cd_convenio_w,
		cd_categoria_w,
		coalesce(cd_profissional_w,cd_pes_fis_regra_w),
		cd_medico_exec_w,
		cd_cgc_prest_regra_w
	    );
	
	    ds_erro_w := consiste_exec_procedimento(nr_seq_proc_pac_w, ds_erro_w);
	    CALL atualiza_preco_procedimento(nr_seq_proc_pac_w, cd_convenio_w, nm_usuario_p);
	    CALL gerar_lancamento_automatico(nr_atendimento_p,cd_local_estoque_w,34,nm_usuario_p,nr_seq_proc_pac_w,NULL,NULL,NULL,NULL,NULL);
        END IF;
     END LOOP;
     CLOSE c01;

     COMMIT;

     END;
     END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_inserir_proced_conta ( nr_atendimento_p bigint, ie_forma_geracao_p text, nm_usuario_p text, cd_setor_atendimento_p bigint, ie_tipo_dialise_p text ) FROM PUBLIC;

