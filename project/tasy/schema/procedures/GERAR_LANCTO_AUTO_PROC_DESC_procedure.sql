-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_lancto_auto_proc_desc ( nr_atendimento_p bigint, nr_seq_procedimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


					
nr_sequencia_w		bigint;
cd_setor_atendimento_w	integer;
cd_setor_atendimento_ww	integer;
dt_entrada_unidade_w	timestamp;
cd_unidade_medida_w	varchar(30);
nr_seq_atepacu_w	bigint;
cd_convenio_w		integer;
cd_categoria_w		varchar(10);
nr_doc_convenio_w	varchar(20);
ie_tipo_guia_w		varchar(2);
cd_senha_w		varchar(20);
cd_estab_w		bigint;
dt_entrada_unidade_ww	timestamp;
cd_pessoa_fisica_w	varchar(10);
nr_seq_interno_w	bigint;
nr_seq_lente_w		bigint;
cd_material_w		integer;
nr_seq_lente_ww		bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
nr_seq_proc_interno_w	bigint;
dt_procedimento_w		timestamp;
cd_profissional_w		varchar(10);
cd_medico_w				varchar(10);
qt_reg_w				bigint;
qt_procedimento_w	double precision;
cd_medico_executor_w    proc_pac_descricao.cd_medico_executor%type;
ie_gerar_proc_faturavel varchar(10);


BEGIN

nr_seq_atepacu_w := obter_atepacu_paciente(nr_atendimento_p,'A');

SELECT * FROM obter_convenio_execucao(nr_atendimento_p, clock_timestamp(), cd_convenio_w, cd_categoria_w, nr_doc_convenio_w, ie_tipo_guia_w, cd_senha_w) INTO STRICT cd_convenio_w, cd_categoria_w, nr_doc_convenio_w, ie_tipo_guia_w, cd_senha_w;

select	cd_estabelecimento
into STRICT	cd_estab_w
from  	atendimento_paciente
where 	nr_atendimento = nr_atendimento_p;

if 	(nr_seq_procedimento_p > 0 AND nr_seq_atepacu_w > 0) then



	select	cd_procedimento,
			ie_origem_proced,
			nr_seq_proc_interno,
			dt_registro,
			cd_profissional,
			qt_procedimento,
            cd_medico_executor
	into STRICT	cd_procedimento_w,
			ie_origem_proced_w,
			nr_seq_proc_interno_w,
			dt_procedimento_w,
			cd_profissional_w,
			qt_procedimento_w,
            cd_medico_executor_w
	from	PROC_PAC_DESCRICAO
	where	nr_sequencia	= nr_seq_procedimento_p;

			
	select	cd_setor_Atendimento,
			dt_entrada_unidade
	into STRICT	cd_setor_atendimento_w,
			dt_entrada_unidade_w
	from	atend_paciente_unidade
	where	nr_seq_interno = nr_seq_atepacu_w;
	
	select	count(*)
	into STRICT	qt_reg_w
	from	medico a,
			pessoa_fisica b,
			conselho_profissional c
	where	a.cd_pessoa_fisica	= cd_profissional_w
	and		a.cd_pessoa_fisica	= b.cd_pessoa_fisica
	and		b.NR_SEQ_CONSELHO	= c.nr_sequencia
	and		c.SG_CONSELHO in ('CRM','CRO');
	
	if (qt_reg_w	> 0) then
		cd_medico_w	 := cd_profissional_w;
		cd_profissional_w	:= null;
	end if;

	ie_gerar_proc_faturavel := obter_valor_param_usuario(281, 1676, Obter_Perfil_Ativo, nm_usuario_p,obter_estabelecimento_ativo);	
	if (coalesce(ie_gerar_proc_faturavel,'N') = 'S') then
			SELECT * FROM obter_proc_tab_interno(nr_seq_proc_interno_w, null, nr_atendimento_p, null, cd_procedimento_w, ie_origem_proced_w, cd_setor_atendimento_w, null, cd_convenio_w) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
    end if;	
	
	nr_sequencia_w := Inserir_Procedimento_Paciente(	cd_procedimento_w, qt_procedimento_w, null, nr_seq_proc_interno_w, ie_origem_proced_w, cd_setor_atendimento_w, nr_atendimento_p, cd_estab_w, nm_usuario_p, 'I', 'N', cd_medico_w, nr_seq_atepacu_w, dt_procedimento_w, cd_convenio_w, cd_categoria_w, nr_sequencia_w, null, cd_medico_executor_w);
	update	procedimento_paciente
	set		ds_observacao = OBTER_DESC_EXPRESSAO(726913)||':'||nr_seq_procedimento_p,
			CD_PESSOA_FISICA	= cd_profissional_w, IE_VIA_ACESSO = obter_regra_via_acesso(cd_procedimento_w, ie_origem_proced_w, cd_estab_w, cd_convenio_w)
	where	nr_sequencia = nr_sequencia_w;
	
	commit;
		
	CALL ajustar_partic_proc_pep(nr_seq_procedimento_p,nr_sequencia_w,nm_usuario_p);
	
	CALL atualiza_preco_procedimento(nr_sequencia_w, cd_convenio_w, nm_usuario_p);

end if;

CALL gerar_lancamento_automatico(nr_atendimento_p, null, 34 , nm_usuario_p, nr_sequencia_w,null,null,null,null,null);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_lancto_auto_proc_desc ( nr_atendimento_p bigint, nr_seq_procedimento_p bigint, nm_usuario_p text) FROM PUBLIC;
