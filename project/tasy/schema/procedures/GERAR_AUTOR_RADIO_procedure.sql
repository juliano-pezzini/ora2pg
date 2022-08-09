-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_autor_radio ( nr_seq_tratamento_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_convenio_w convenio.cd_convenio%TYPE;
cd_pessoa_fisica_w pessoa_fisica.cd_pessoa_fisica%TYPE;
cd_medico_w pessoa_fisica.cd_pessoa_fisica%TYPE;
nr_atendimento_w atendimento_paciente.nr_atendimento%TYPE;
nr_seq_tipo_w rxt_tipo.nr_sequencia%TYPE;
nr_seq_protocolo_w rxt_protocolo.nr_sequencia%TYPE;
dt_inicio_trat_w timestamp;
ds_observacao_w rxt_tratamento.ds_observacao%TYPE;
cd_estabelecimento_w estabelecimento.cd_estabelecimento%TYPE := wheb_usuario_pck.get_cd_estabelecimento;
cd_setor_usuario_w setor_atendimento.cd_setor_atendimento%TYPE;
nr_seq_proc_autor_w procedimento_autorizado.nr_sequencia%TYPE;
nr_sequencia_autor_w autorizacao_convenio.nr_sequencia%TYPE;
nr_seq_estagio_w estagio_autorizacao.nr_sequencia%TYPE;
cd_procedimento_w procedimento.cd_procedimento%TYPE;
ie_origem_proced_w procedimento.ie_origem_proced%TYPE;
cd_categoria_w categoria_convenio.cd_categoria%TYPE;
cd_plano_w convenio_plano.cd_plano%TYPE;
ie_tipo_atendimento_w atendimento_paciente.ie_tipo_atendimento%TYPE;
ds_erro_w varchar(2000);
ie_regra_w varchar(15);
nr_seq_regra_retorno_w bigint;
ie_glosa_w regra_ajuste_proc.ie_glosa%TYPE;
nr_seq_regra_preco_w regra_ajuste_proc.nr_sequencia%TYPE;
existe_prot_convenio_w bigint;
ds_observacao_ww varchar(8000);
ds_comp_text_w varchar(3);
nr_seq_motiv_trat_w rxt_motivo_tratamento.nr_sequencia%TYPE;
ds_motivo_tratamento_w rxt_motivo_tratamento.ds_motivo%TYPE;
nr_seq_modalidade_w rxt_tratamento.nr_seq_modalidade%TYPE;
ds_modalidade_w rxt_tipo_modalidade.ds_modalidade%TYPE;
qt_duracao_trat_w rxt_tratamento.qt_duracao_trat%TYPE;
qt_dose_total_w rxt_tratamento.qt_dose_total%TYPE;

c01 CURSOR FOR
SELECT 	a.nr_seq_proc_interno
FROM 	rxt_protocolo_proc_exec a,
	rxt_tratamento	b,
	rxt_tumor	c
WHERE 	a.nr_seq_protocolo = nr_seq_protocolo_w
AND 	b.nr_sequencia	= nr_seq_tratamento_p
AND (a.cd_convenio 	= cd_convenio_w or (coalesce(a.cd_convenio::text, '') = '' and existe_prot_convenio_w = 0))
AND (a.nr_seq_modalidade = b.nr_seq_modalidade or (coalesce(a.nr_seq_modalidade::text, '') = '' and existe_prot_convenio_w = 0))
AND 	coalesce(a.ie_exige_autorizacao, 'N') = 'S'
group by a.nr_seq_proc_interno;

c01_w c01%ROWTYPE;


BEGIN

BEGIN

select	coalesce(sum(nr_sequencia),0)
into STRICT 	existe_prot_convenio_w 
from (SELECT a.nr_sequencia
	from 	rxt_protocolo_proc_exec	a,
		rxt_tratamento	b,
		rxt_protocolo	c
	where 	a.nr_seq_protocolo = b.nr_seq_protocolo
		and b.nr_sequencia = nr_seq_tratamento_p
		and a.cd_convenio = cd_convenio_w
		and a.nr_seq_modalidade = b.nr_seq_modalidade
		and c.ie_situacao = 'A'
	group by a.nr_sequencia
	order by 1
) alias2;

SELECT 	a.cd_convenio,
	a.cd_pessoa_fisica,
	a.cd_medico,
	a.nr_atendimento,
	b.nr_seq_protocolo,
	b.dt_inicio_trat,
	b.ds_observacao,
	b.nr_seq_motivo,
	b.nr_seq_modalidade,
	b.qt_duracao_trat,
	b.qt_dose_total
INTO STRICT 	cd_convenio_w,
	cd_pessoa_fisica_w,
	cd_medico_w,
	nr_atendimento_w,
	nr_seq_protocolo_w,
	dt_inicio_trat_w,
	ds_observacao_w,
	nr_seq_motiv_trat_w,
	nr_seq_modalidade_w,
	qt_duracao_trat_w,
	qt_dose_total_w
FROM 	rxt_tumor a,
	rxt_tratamento b
WHERE 	a.nr_sequencia = b.nr_seq_tumor
AND 	b.nr_sequencia = nr_seq_tratamento_p
AND NOT EXISTS (SELECT 1
		FROM autorizacao_convenio x
		WHERE x.nr_seq_rxt_tratamento = b.nr_sequencia);
EXCEPTION WHEN OTHERS
THEN CALL wheb_mensagem_pck.Exibir_mensagem_abort(311161);

END;

IF (nr_seq_protocolo_w IS NOT NULL AND nr_seq_protocolo_w::text <> '') THEN
	SELECT Max(cd_setor_atendimento) INTO STRICT cd_setor_usuario_w
	FROM usuario
	WHERE nm_usuario = nm_usuario_p;

	SELECT Min(nr_sequencia)
	INTO STRICT nr_seq_estagio_w
	FROM estagio_autorizacao a
	WHERE a.ie_interno = '1'
	AND coalesce(a.ie_situacao, 'A') = 'A'
	AND a.cd_empresa = Obter_empresa_estab(cd_estabelecimento_w);
IF (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') THEN
	SELECT 	Substr(Obter_categoria_atendimento(nr_atendimento), 1, 10),
		Substr(Obter_plano_atendimento(nr_atendimento, 'C'), 1, 10),
		ie_tipo_atendimento 
	INTO STRICT 	cd_categoria_w,
		cd_plano_w,
		ie_tipo_atendimento_w
	FROM 	atendimento_paciente
	WHERE 	nr_atendimento = nr_atendimento_w;
END IF;

select max(a.ds_motivo)
into STRICT ds_motivo_tratamento_w
from rxt_motivo_tratamento a
where a.nr_sequencia = nr_seq_motiv_trat_w;

select max(a.ds_modalidade)
into STRICT ds_modalidade_w
from rxt_tipo_modalidade a
where a.nr_sequencia = nr_seq_modalidade_w;

ds_comp_text_w := Wheb_mensagem_pck.get_texto(1118240); /* : */
ds_observacao_ww := Wheb_mensagem_pck.get_texto(308492) ||  ' ' /*'Protocolo: '*/ || substr(rxt_obter_nome_protocolo(nr_seq_protocolo_w),1,255)
			|| chr(13) || Wheb_mensagem_pck.get_texto(1159194) || 	ds_comp_text_w  || ' ' /*'Finalidade '*/|| 	ds_motivo_tratamento_w
			|| chr(13) || Wheb_mensagem_pck.get_texto(1159203) || 	ds_comp_text_w  || ' ' /*'Modalidade '*/|| 	ds_modalidade_w
			|| chr(13) || Wheb_mensagem_pck.get_texto(343293) || 	ds_comp_text_w  || ' ' /*'Dias aplicacao'*/|| 	qt_duracao_trat_w
			|| chr(13) || Wheb_mensagem_pck.get_texto(1159195 ) || 	ds_comp_text_w  || ' ' /*'Dose total (Gy) '*/|| qt_dose_total_w
			|| chr(13) || Wheb_mensagem_pck.get_texto(42256) || ' ' /*'Observacao '*/ || ds_observacao_w;

ds_observacao_w := substr(ds_observacao_ww, 1, 4000);

SELECT 	nextval('autorizacao_convenio_seq')
INTO STRICT 	nr_sequencia_autor_w
;

INSERT INTO autorizacao_convenio(nr_atendimento, nr_seq_autorizacao, cd_convenio, cd_autorizacao, dt_autorizacao,
	dt_inicio_vigencia, dt_atualizacao, nm_usuario, dt_fim_vigencia, nm_responsavel, ds_observacao,
	cd_senha, cd_procedimento_principal, ie_origem_proced, dt_pedido_medico, cd_medico_solicitante,
	ie_tipo_guia, qt_dia_autorizado, nr_prescricao, dt_envio, dt_retorno,
	nr_seq_estagio, ie_tipo_autorizacao, ie_tipo_dia, cd_tipo_acomodacao, nr_sequencia,
	nr_seq_agenda, ie_carater_int_tiss, ie_resp_autor, nr_seq_agenda_consulta, nr_seq_agenda_proc,
	nr_seq_age_integ, qt_dias_prazo, ds_indicacao, qt_dia_solicitado, cd_setor_origem,
	nr_seq_classif, dt_entrada_prevista, nr_seq_regra_autor, cd_pessoa_fisica, cd_estabelecimento,
	dt_agenda, dt_agenda_cons, dt_agenda_integ, ie_tiss_tipo_anexo_autor, nr_seq_proc_interno,
	nr_seq_rxt_tratamento, dt_atualizacao_nrec, nm_usuario_nrec)
VALUES (nr_atendimento_w,
        NULL,
        cd_convenio_w,
        NULL,
        clock_timestamp(),
        dt_inicio_trat_w,
        clock_timestamp(),
        nm_usuario_p,
        NULL,
        NULL,
        ds_observacao_w,
        NULL,
        NULL,
        NULL,
        NULL,
        cd_medico_w,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        nr_seq_estagio_w,
        '3',
        'C',
        NULL,
        nr_sequencia_autor_w,
        NULL,
        NULL,
        'H',
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        cd_setor_usuario_w,
        NULL,
        NULL,
        NULL,
        cd_pessoa_fisica_w,
        cd_estabelecimento_w,
        NULL,
        NULL,
        NULL,
        '3',
        NULL,
        nr_seq_tratamento_p,
        clock_timestamp(),
        nm_usuario_p);

OPEN c01;

LOOP FETCH c01 INTO c01_w;

EXIT WHEN NOT FOUND; /* apply on c01 */

BEGIN
	SELECT * FROM Obter_proc_tab_interno(c01_w.nr_seq_proc_interno, NULL, nr_atendimento_w, NULL, cd_procedimento_w, ie_origem_proced_w, NULL, NULL, NULL) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
	SELECT * FROM Consiste_plano_convenio(nr_atendimento_w, cd_convenio_w, cd_procedimento_w, ie_origem_proced_w, clock_timestamp(), 1, ie_tipo_atendimento_w, cd_plano_w, NULL, ds_erro_w, cd_setor_usuario_w, NULL, ie_regra_w, NULL, nr_seq_regra_retorno_w, c01_w.nr_seq_proc_interno, cd_categoria_w, cd_estabelecimento_w, NULL, cd_medico_w, cd_pessoa_fisica_w, ie_glosa_w, nr_seq_regra_preco_w) INTO STRICT ds_erro_w, ie_regra_w, nr_seq_regra_retorno_w, ie_glosa_w, nr_seq_regra_preco_w;

	IF (ie_regra_w IN ('3','6','7')) THEN
		SELECT nextval('procedimento_autorizado_seq') INTO STRICT nr_seq_proc_autor_w
		;

		INSERT INTO procedimento_autorizado(nr_atendimento, nr_seq_autorizacao, cd_procedimento, ie_origem_proced, qt_solicitada,
			qt_autorizada, dt_atualizacao, nm_usuario, nr_sequencia_autor, nr_sequencia,
			nr_seq_proc_interno, nr_seq_regra_plano)
		VALUES (nr_atendimento_w,
			NULL,
			cd_procedimento_w,
			ie_origem_proced_w,
			1,
			0,
			clock_timestamp(),
			nm_usuario_p,
			nr_sequencia_autor_w,
			nr_seq_proc_autor_w,
			c01_w.nr_seq_proc_interno,
			nr_seq_regra_retorno_w);
	END IF;
END;
END LOOP;
CLOSE c01;

IF (nr_sequencia_autor_w IS NOT NULL AND nr_sequencia_autor_w::text <> '') THEN CALL Tiss_gerar_anexo_guia(nr_sequencia_autor_w, nm_usuario_p);

END IF;

END IF;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_autor_radio ( nr_seq_tratamento_p bigint, nm_usuario_p text) FROM PUBLIC;
