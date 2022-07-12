-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE kodip_pck.receive_ze_procedures ( reg_integracao_p INOUT gerar_int_padrao.reg_integracao_conv, nr_seq_episodio_p bigint, grres_p xml, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

			
cd_proc_w      		procedimento.cd_procedimento%type;	
ie_origem_proc_w 	procedimento.ie_origem_proced%type;
dt_entrada_unidade_w	timestamp;
nr_seq_propaci_ze_w	bigint;	
cd_convenio_w		procedimento_paciente.cd_convenio%type;
cd_categoria_w		procedimento_paciente.cd_categoria%type;
nr_doc_convenio_w	procedimento_paciente.nr_doc_convenio%type;
ie_tipo_guia_w		procedimento_paciente.ie_tipo_guia%type;
cd_senha_w		procedimento_paciente.cd_senha%type;
seq_atepacu_w  		bigint;
setor_atend_w  		bigint;
ds_erro_w		varchar(4000);
			
--ze procedure
c01 CURSOR FOR
SELECT	*
from	xmltable('/GrouperResult/ZeList/Ze' passing grres_p columns
		zecode 	varchar(15) path '@ZeCode',
		zetext 	varchar(255) path '@ZeText',
		zeprice varchar(255) path '@ZePrice');

c01_w          c01%rowtype;			


BEGIN
reg_integracao_p := kodip_pck.clear_ze_drg(reg_integracao_p, nr_seq_episodio_p, nm_usuario_p);

open c01;
	loop
	fetch c01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		seq_atepacu_w := obter_atepacu_paciente(nr_atendimento_p, 'A');
		setor_atend_w := obter_setor_atendimento(nr_atendimento_p);

		select	max(cd_procedimento),
			max(ie_origem_proced)
		into STRICT	cd_proc_w,
			ie_origem_proc_w
		from 	procedimento
		where 	cd_procedimento_loc = c01_w.zecode;

		select	max(a.dt_entrada_unidade)
		into STRICT	dt_entrada_unidade_w
		from	atend_paciente_unidade a
		where	nr_seq_interno	= seq_atepacu_w;		

		if (cd_proc_w IS NOT NULL AND cd_proc_w::text <> '') and (ie_origem_proc_w IS NOT NULL AND ie_origem_proc_w::text <> '') then			
			
			begin
			select	nr_sequencia
			into STRICT	nr_seq_propaci_ze_w
			from	procedimento_paciente a,
				conta_paciente b,
				atendimento_paciente c
			where	a.nr_interno_conta	= b.nr_interno_conta
			and	b.nr_atendimento	= c.nr_atendimento
			and	c.nr_seq_episodio	= nr_seq_episodio_p
			and	coalesce(c.dt_cancelamento::text, '') = ''
			and	a.cd_procedimento	= cd_proc_w
			and	a.ie_origem_proced	= ie_origem_proc_w
			and	coalesce(a.cd_motivo_exc_conta::text, '') = ''  LIMIT 1;		
			exception
			when others then
				nr_seq_propaci_ze_w := null;
			end;
			
			if (coalesce(nr_seq_propaci_ze_w::text, '') = '') then --somente 1 item por case
			
				obter_convenio_execucao(nr_atendimento_p,
							clock_timestamp(),
							cd_convenio_w,
							cd_categoria_w,
							nr_doc_convenio_w,
							ie_tipo_guia_w,
							cd_senha_w);
			
				select	nextval('procedimento_paciente_seq')
				into STRICT	nr_seq_propaci_ze_w
				;

				insert into procedimento_paciente(
					nr_sequencia,
					nr_atendimento,
					cd_procedimento,
					ie_auditoria,
					vl_procedimento,
					ie_proc_princ_atend,
					ie_video,
					tx_medico,
					tx_anestesia,
					tx_procedimento,
					ie_valor_informado,
					nm_usuario_original,
					dt_atualizacao,
					dt_entrada_unidade,
					dt_procedimento,
					qt_procedimento,
					cd_setor_atendimento,
					ie_origem_proced,
					nr_seq_atepacu,
					nm_usuario,
					cd_convenio,
					cd_categoria,
					nr_doc_convenio,
					ie_tipo_guia,
					cd_senha)
				values (	nr_seq_propaci_ze_w,
					nr_atendimento_p,
					cd_proc_w,
					'N',
					to_number(c01_w.zeprice, '999999999999999.99'),
					'N',
					'N',
					100,
					100,
					100,
					'S',
					nm_usuario_p,
					clock_timestamp(),
					dt_entrada_unidade_w,
					clock_timestamp(),
					1,
					setor_atend_w,
					ie_origem_proc_w,
					seq_atepacu_w,
					nm_usuario_p,
					cd_convenio_w,
					cd_categoria_w,
					nr_doc_convenio_w,
					ie_tipo_guia_w,
					cd_senha_w);
				
				CALL atualiza_preco_procedimento(nr_seq_propaci_ze_w, cd_convenio_w, nm_usuario_p);
			end if;

			CALL kodip_pck.generate_items_reg('TAX',clock_timestamp(), cd_proc_w, ie_origem_proc_w, null, 'KODIP', null, nr_seq_propaci_ze_w);
		else
			--nao foi localizado um registro do procedimento #@cd_proced_p#@ com a origem #@ie_orig_p#@ na tabela de procedimentos!
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1046324,'CD_PROCED_P='||c01_w.zecode||';IE_ORIG_P='||null);
		end if;
		commit;
		exception
		when others then
			begin
			ds_erro_w	:=	substr('Error reading c01-GrRes/GrouperResult/ZeList/Ze: ' || sqlerrm || chr(13) || chr(10) ||
							dbms_utility.format_error_backtrace,1, 2000);
			CALL CALL kodip_pck.incluir_log(reg_integracao_p, ds_erro_w, 'KODIP-RECEIVE', 'W');
			rollback;
			end;
		end;
	end loop;
	close c01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE kodip_pck.receive_ze_procedures ( reg_integracao_p INOUT gerar_int_padrao.reg_integracao_conv, nr_seq_episodio_p bigint, grres_p xml, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;
