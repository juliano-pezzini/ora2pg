-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rxt_lancar_checkfilm_conta ( nr_seq_rxt_tratamento_p bigint, qt_check_film_p bigint, cd_pessoa_fisica_p text, cd_setor_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_atendimento_w		rxt_tumor.nr_atendimento%type;
cd_procedimento_w		rxt_proced_faturamento.cd_procedimento%type;
cd_convenio_w			atend_categoria_convenio.cd_convenio%type;
cd_categoria_w			atend_categoria_convenio.cd_categoria%type;
nr_seq_proc_pac_w		procedimento_paciente.nr_sequencia%type;
ie_origem_proced_w		proc_interno.ie_origem_proced%type;
ds_erro_w			varchar(255);
dt_entrada_unidade_w		atend_paciente_unidade.dt_entrada_unidade%type;
nr_seq_atepacu_w		atend_paciente_unidade.nr_seq_interno%type;
cd_setor_atend_pac_w		atend_paciente_unidade.cd_setor_atendimento%type;

C01 CURSOR FOR
	SELECT	cd_convenio,
		nr_seq_proc_interno,
		null cd_procedimento,
		ie_origem_proced
	from	rxt_proced_faturamento
	where	ie_tipo_lancamento = 'C'
	and	ie_situacao = 'A'
	and	(nr_seq_proc_interno IS NOT NULL AND nr_seq_proc_interno::text <> '')
	
union all

	SELECT	cd_convenio,
		null nr_seq_proc_interno,
		cd_procedimento,
		ie_origem_proced
	from	rxt_proced_faturamento
	where	ie_tipo_lancamento = 'C'
	and	ie_situacao = 'A'
	and	(cd_procedimento IS NOT NULL AND cd_procedimento::text <> '');
BEGIN

--substr(Rxt_Obter_Tipo_Trat_Prot(nr_seq_protocolo),1,5)
if (nr_seq_rxt_tratamento_p IS NOT NULL AND nr_seq_rxt_tratamento_p::text <> '') and (qt_check_film_p IS NOT NULL AND qt_check_film_p::text <> '') then
	
	select	max(a.nr_atendimento)
	into STRICT	nr_atendimento_w
	from	rxt_tumor a,
		rxt_tratamento b
	where	a.nr_sequencia = b.nr_seq_tumor
	and	b.nr_sequencia = nr_seq_rxt_tratamento_p;
	
	cd_setor_atend_pac_w := Obter_Setor_Atendimento(nr_atendimento_w);
	if (coalesce(cd_setor_atend_pac_w::text, '') = '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(711093);
	end if;
	
	select 	coalesce(max(w.dt_entrada_unidade), clock_timestamp())
	into STRICT	dt_entrada_unidade_w
	from   	atend_paciente_unidade w
	where  	w.nr_atendimento 	= nr_atendimento_w
	and    	w.cd_setor_atendimento 	= cd_setor_atend_pac_w;
	
	/*SO-2225714*/

	select	max(a.nr_seq_interno)
	into STRICT	nr_seq_atepacu_w
	from 	atend_paciente_unidade a
	where 	a.cd_setor_atendimento		= cd_setor_atend_pac_w
	and	a.nr_atendimento 		= nr_atendimento_w
	and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(a.dt_entrada_unidade) = ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_entrada_unidade_w);
		
	cd_convenio_w 	:= obter_convenio_atendimento(nr_atendimento_w);
	cd_categoria_w	:= obter_categoria_atendimento(nr_atendimento_w);

	for	row_C01 in C01 loop

		if (coalesce(row_C01.cd_convenio::text, '') = '') or (row_C01.cd_convenio = cd_convenio_w) then
			
			cd_procedimento_w	:= null;
			ie_origem_proced_w	:= null;
			
			if (row_C01.nr_seq_proc_interno IS NOT NULL AND row_C01.nr_seq_proc_interno::text <> '') then
			
				SELECT * FROM obter_proc_tab_interno_conv(
					row_C01.nr_seq_proc_interno, wheb_usuario_pck.get_cd_estabelecimento, cd_convenio_w, cd_categoria_w, null, null, cd_procedimento_w, ie_origem_proced_w, null, clock_timestamp(), null, null, null, null, null, null, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
					
			end if;
				
			select 	nextval('procedimento_paciente_seq')
			into STRICT  	nr_seq_proc_pac_w
			;

			insert into procedimento_paciente(
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
				cd_pessoa_fisica
			) values (	
				nr_seq_proc_pac_w,
				nr_atendimento_w,
				dt_entrada_unidade_w,
				coalesce(row_C01.cd_procedimento, cd_procedimento_w),
				clock_timestamp(),
				qt_check_film_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_setor_atendimento_p,
				coalesce(row_C01.ie_origem_proced, ie_origem_proced_w),
				nr_seq_atepacu_w,
				row_C01.nr_seq_proc_interno,
				cd_convenio_w,
				cd_categoria_w,
				cd_pessoa_fisica_p);
			
			insert into rxt_tratamento_proced(
				nr_sequencia,
				nr_seq_tratamento,
				nr_seq_propaci,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				ie_situacao
			) values (
				nextval('rxt_tratamento_proced_seq'),
				nr_seq_rxt_tratamento_p,
				nr_seq_proc_pac_w,
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				'A');
				
			ds_erro_w := consiste_exec_procedimento(nr_seq_proc_pac_w, ds_erro_w);
			CALL atualiza_preco_procedimento(nr_seq_proc_pac_w, cd_convenio_w, nm_usuario_p);

			commit;
			
		end if;
		
	end loop;
	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rxt_lancar_checkfilm_conta ( nr_seq_rxt_tratamento_p bigint, qt_check_film_p bigint, cd_pessoa_fisica_p text, cd_setor_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

