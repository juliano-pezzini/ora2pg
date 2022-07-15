-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE get_finish_task_diagnoses ( nr_atendimento_p bigint, nm_usuario_p text ) AS $body$
DECLARE


cd_doenca_w				  	medic_diagnostico_doenca.cd_doenca%type;
dt_diagnostico_w		  	medic_diagnostico_doenca.dt_diagnostico%type;
nr_seq_interno_w		  	diagnostico_doenca.nr_seq_interno%type;
ie_situacao_diag_doenca_w	diagnostico_doenca.ie_situacao%type;
ie_tipo_diagnostico_w		diagnostico_doenca.ie_tipo_diagnostico%type;
nr_seq_classif_diag_w 		classificacao_diagnostico.nr_sequencia%type;
ie_diagnostico_admissao_w 	classificacao_diagnostico.ie_diagnostico_admissao%type;
ie_usa_case_w				varchar(1);
nr_seq_episodio_w			episodio_paciente.nr_sequencia%type;


BEGIN

	select	obter_uso_case(nm_usuario_p)
	into STRICT	ie_usa_case_w
	;

	if (ie_usa_case_w = 'S') then

		select	nr_seq_episodio
		into STRICT	nr_seq_episodio_w
		from	atendimento_paciente
		where	nr_atendimento = nr_atendimento_p;

		select	coalesce(max(d.cd_doenca), 'XXX'),
				coalesce(max(d.dt_diagnostico), clock_timestamp()),
				coalesce(max(ie_diagnostico_admissao), 'N'),
				coalesce(max(c.nr_sequencia), 0),
				coalesce(max(e.nr_seq_interno), 0)
		into STRICT	cd_doenca_w,
				dt_diagnostico_w,
				ie_diagnostico_admissao_w,
				nr_seq_classif_diag_w,
				nr_seq_interno_w
		from	classificacao_diagnostico c,
				medic_diagnostico_doenca d,
				diagnostico_doenca e
		where	c.nr_sequencia	= d.nr_seq_classificacao
		and		d.nr_atendimento in (SELECT x.nr_atendimento from atendimento_paciente x, episodio_paciente y where x.nr_seq_episodio = y.nr_sequencia and y.nr_sequencia = nr_seq_episodio_w)
		and		c.ie_diagnostico_admissao = 'S'
		and		e.nr_atendimento = d.nr_atendimento
		and		e.cd_doenca = d.cd_doenca
		and		e.dt_diagnostico = d.dt_diagnostico
		and		(e.dt_liberacao IS NOT NULL AND e.dt_liberacao::text <> '')
		and		coalesce(e.dt_inativacao::text, '') = ''
		and		d.ie_situacao = 'A'
		and		c.ie_situacao = 'A';

		if (ie_diagnostico_admissao_w <> 'N' and nr_seq_interno_w > 0) then
			CALL wl_gerar_finalizar_tarefa('DG','F',nr_atendimento_p,obter_pessoa_atendimento(nr_atendimento_p,'C'),nm_usuario_p,clock_timestamp(),'S',null,null,null,null,null,null,null,null,nr_seq_interno_w,null,null,null,null,null,null,null,nr_seq_classif_diag_w,null,nr_seq_episodio_w);
		end if;

		select	coalesce(max(a.nr_seq_diagnostico), 0),
				coalesce(max(a.ie_tipo_diagnostico), ''),
				coalesce(max(a.nr_seq_classif_diag), 0)
		into STRICT	nr_seq_interno_w,
				ie_tipo_diagnostico_w,
				nr_seq_classif_diag_w
		from	wl_worklist a,
				wl_regra_item b
		where	b.nr_sequencia = a.nr_seq_regra
		and		a.nr_atendimento in (SELECT x.nr_atendimento from atendimento_paciente x, episodio_paciente y where x.nr_seq_episodio = y.nr_sequencia and y.nr_sequencia = nr_seq_episodio_w)
		and		(b.nr_seq_classif_diag IS NOT NULL AND b.nr_seq_classif_diag::text <> '');

		if (ie_diagnostico_admissao_w <> 'S' and nr_seq_interno_w > 0) then
			CALL wl_gerar_finalizar_tarefa('DG','R',nr_atendimento_p,obter_pessoa_atendimento(nr_atendimento_p,'C'),nm_usuario_p,clock_timestamp(),'S',null,null,null,null,null,null,null,null,nr_seq_interno_w,null,ie_tipo_diagnostico_w,null,null,null,null,null,nr_seq_classif_diag_w,null,nr_seq_episodio_w);
		end if;

	else

		select	coalesce(max(d.cd_doenca), 'XXX'),
				coalesce(max(d.dt_diagnostico), clock_timestamp()),
				coalesce(max(ie_diagnostico_admissao), 'N'),
				coalesce(max(c.nr_sequencia), 0),
				coalesce(max(e.nr_seq_interno), 0)
		into STRICT	cd_doenca_w,
				dt_diagnostico_w,
				ie_diagnostico_admissao_w,
				nr_seq_classif_diag_w,
				nr_seq_interno_w
		from	classificacao_diagnostico c,
				medic_diagnostico_doenca d,
				diagnostico_doenca e
		where	c.nr_sequencia	= d.nr_seq_classificacao
		and		d.nr_atendimento	= nr_atendimento_p
		and		c.ie_diagnostico_admissao = 'S'
		and		e.nr_atendimento = d.nr_atendimento
		and		e.cd_doenca = d.cd_doenca
		and		e.dt_diagnostico = d.dt_diagnostico
		and		(e.dt_liberacao IS NOT NULL AND e.dt_liberacao::text <> '')
		and		coalesce(e.dt_inativacao::text, '') = ''
		and		d.ie_situacao = 'A'
		and		c.ie_situacao = 'A';

		if (ie_diagnostico_admissao_w <> 'N' and nr_seq_interno_w > 0) then
			CALL wl_gerar_finalizar_tarefa('DG','F',nr_atendimento_p,obter_pessoa_atendimento(nr_atendimento_p,'C'),nm_usuario_p,clock_timestamp(),'S',null,null,null,null,null,null,null,null,nr_seq_interno_w,null,null,null,null,null,null,null,nr_seq_classif_diag_w);
		end if;

		select	coalesce(max(a.nr_seq_diagnostico), 0),
				coalesce(max(a.ie_tipo_diagnostico), ''),
				coalesce(max(a.nr_seq_classif_diag), 0)
		into STRICT	nr_seq_interno_w,
				ie_tipo_diagnostico_w,
				nr_seq_classif_diag_w
		from	wl_worklist a,
				wl_regra_item b
		where	b.nr_sequencia = a.nr_seq_regra
		and		a.nr_atendimento = nr_atendimento_p
		and		(b.nr_seq_classif_diag IS NOT NULL AND b.nr_seq_classif_diag::text <> '');

		if (ie_diagnostico_admissao_w <> 'S' and nr_seq_interno_w > 0) then
			CALL wl_gerar_finalizar_tarefa('DG','R',nr_atendimento_p,obter_pessoa_atendimento(nr_atendimento_p,'C'),nm_usuario_p,clock_timestamp(),'S',null,null,null,null,null,null,null,null,nr_seq_interno_w,null,ie_tipo_diagnostico_w,null,null,null,null,null,nr_seq_classif_diag_w);
		end if;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE get_finish_task_diagnoses ( nr_atendimento_p bigint, nm_usuario_p text ) FROM PUBLIC;

