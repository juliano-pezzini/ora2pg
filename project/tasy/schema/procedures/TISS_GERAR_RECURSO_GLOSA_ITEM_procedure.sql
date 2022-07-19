-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE tiss_itens_recursos AS (
				cd_autorizacao                     varchar(20),
				cd_procedimento		            varchar(20),
                nr_interno_conta                  bigint,
                nr_sequencia_item                bigint,
		dt_item				timestamp,
                ie_item_adicionado               varchar(1)
);


CREATE OR REPLACE PROCEDURE tiss_gerar_recurso_glosa_item (nr_seq_hist_item_p bigint, nm_usuario_p text, nr_seq_rec_guia_p bigint) AS $body$
DECLARE


nr_seq_propaci_w			lote_audit_hist_item.nr_seq_propaci%type;
nr_seq_matpaci_w			lote_audit_hist_item.nr_seq_matpaci%type;
cd_motivo_glosa_w			lote_audit_hist_item.cd_motivo_glosa%type;
vl_amenor_w			lote_audit_hist_item.vl_amenor%type;
nr_seq_lote_hist_item_w		lote_audit_hist_item.nr_sequencia%type;
nr_seq_partic_w         	lote_audit_hist_item.nr_seq_partic%type;

cd_convenio_w			lote_auditoria.cd_convenio%type;
cd_estabelecimento_w		lote_auditoria.cd_estabelecimento%type;

cd_procedimento_w		procedimento_paciente.cd_procedimento%type;
ie_origem_proced_w		procedimento_paciente.ie_origem_proced%type;
cd_procedimento_tuss_w		procedimento_paciente.cd_procedimento_tuss%type;
ds_proc_tiss_w			procedimento_paciente.ds_proc_tiss%type;
nr_seq_proc_interno_w		procedimento_paciente.nr_seq_proc_interno%type;
nr_seq_exame_w			procedimento_paciente.nr_seq_exame%type;
cd_procedimento_convenio_w	procedimento_paciente.cd_procedimento_convenio%type;
ie_funcao_medico_w		procedimento_paciente.ie_funcao_medico%type;
cd_edicao_amb_proc_w		procedimento_paciente.cd_edicao_amb%type;
nr_seq_proc_pacote_w		procedimento_paciente.nr_seq_proc_pacote%type;

cd_categoria_parametro_w		conta_paciente.cd_categoria_parametro%type;
nr_atendimento_w			conta_paciente.nr_atendimento%type;

nr_seq_motivo_glosa_w		bigint;
ds_justificativa_w		varchar(150);
ie_codigo_tuss_w		varchar(2);
ie_desc_tuss_w			varchar(2);
dt_procedimento_w		timestamp;
dt_conta_w			timestamp;
dt_fim_procedimento_w		timestamp;
ie_classif_proced_w		varchar(1);
ds_procedimento_w			varchar(255);
ds_proc_tabela_w		varchar(255);
cd_procedimento_tiss_w		varchar(20);
ie_proc_pacote_w		varchar(2);
nr_seq_tiss_tabela_w		bigint;
cd_edicao_amb_w			varchar(2);
cd_material_w			integer;
ds_motivo_glosa_w		varchar(255);
cd_motivo_glosa_tiss_w		varchar(10);
ie_motivo_glosa_conv_w		varchar(10);
nr_interno_conta_w		bigint;
ie_tiss_tipo_guia_w		varchar(2);
nr_seq_ret_glosa_w		bigint;
ie_data_rec_glosa_tiss_w	tiss_parametros_convenio.ie_data_rec_glosa_tiss%type;

nr_sequencia_item_w smallint;
cd_autorizacao_w varchar(20);
nr_interno_conta_item_w bigint;
cd_procedimento_item_w bigint;
DAY_C CONSTANT varchar(2) := 'dd';
it bigint;

type tiss_itens_recurso_v is table of tiss_itens_recursos index by integer;
tiss_itens_recurso_w tiss_itens_recurso_v;

c01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_seq_propaci,
	a.nr_seq_matpaci,
	a.cd_motivo_glosa,
	a.vl_amenor,
	tiss_eliminar_caractere(substr(a.ds_observacao,1,150)), --padrao TISS somente permite 150 caracteres
	a.cd_motivo_glosa_tiss,
	a.nr_seq_ret_glosa,
	b.nr_interno_conta,
	b.cd_autorizacao,
	a.ie_funcao_medico,
	a.nr_sequencia_item,
	a.nr_seq_partic
from	lote_audit_hist_item a, lote_audit_hist_guia b
where	a.nr_seq_guia	= nr_seq_hist_item_p
and 	a.nr_seq_guia = b.nr_sequencia
and	a.ie_acao_glosa	in ('P','R')
and	coalesce(a.vl_amenor,0) > 0;

c02 CURSOR FOR
SELECT 	a.ie_codigo_tuss,
		a.ie_desc_tuss
from 	tiss_regra_tuss a
where	a.cd_estabelecimento	= cd_estabelecimento_w
and 	a.cd_convenio		= cd_convenio_w
and 	a.dt_inicio_vigencia	<= dt_procedimento_w
and (exists (SELECT	1
			from	tiss_regra_tuss_filtro x
			where	x.nr_seq_regra						= a.nr_sequencia
			and	coalesce(x.ie_classif_proced,coalesce(ie_classif_proced_w,'X'))	= coalesce(ie_classif_proced_w,'X')) or
	not exists (select	1
			from	tiss_regra_tuss_filtro x
			where	x.nr_seq_regra				= a.nr_sequencia))
order by a.dt_inicio_vigencia;

  nr_count_w RECORD;
  nr_count_ww RECORD;

BEGIN

it := 0;

for nr_count_w in (SELECT distinct b.nr_interno_conta, b.cd_autorizacao
            from	lote_audit_hist_guia b
            where b.nr_sequencia = nr_seq_hist_item_p )
    loop

     for nr_count_ww in (
			SELECT cd_procedimento, nr_sequencia_item, dt_item  
			from tiss_conta_desp 
			where nr_interno_conta = nr_count_w.nr_interno_conta
			order by nr_sequencia_item
		    ) 
        loop
        tiss_itens_recurso_w[it].nr_interno_conta :=nr_count_w.nr_interno_conta;
        tiss_itens_recurso_w[it].cd_autorizacao := nr_count_w.cd_autorizacao;
        tiss_itens_recurso_w[it].cd_procedimento := nr_count_ww.cd_procedimento;
        tiss_itens_recurso_w[it].nr_sequencia_item := nr_count_ww.nr_sequencia_item;
	tiss_itens_recurso_w[it].dt_item := nr_count_ww.dt_item;
        tiss_itens_recurso_w[it].ie_item_adicionado := 'N';
        it := it + 1;
    end loop;

    for nr_count_ww in (
			SELECT cd_procedimento, nr_sequencia_item, dt_procedimento
			from tiss_conta_proc 
			where nr_interno_conta = nr_count_w.nr_interno_conta
			order by nr_sequencia_item
			) 
        loop
         tiss_itens_recurso_w[it].nr_interno_conta :=nr_count_w.nr_interno_conta;
        tiss_itens_recurso_w[it].cd_autorizacao := nr_count_w.cd_autorizacao;
        tiss_itens_recurso_w[it].cd_procedimento := nr_count_ww.cd_procedimento;
        tiss_itens_recurso_w[it].nr_sequencia_item := nr_count_ww.nr_sequencia_item;
	tiss_itens_recurso_w[it].dt_item := nr_count_ww.dt_procedimento;
        tiss_itens_recurso_w[it].ie_item_adicionado := 'N';
        it := it + 1;
    end loop;

end loop;

it := 0;

select	max(a.cd_convenio),
	max(a.cd_estabelecimento),
	max(c.nr_interno_conta)
into STRICT	cd_convenio_w,
	cd_estabelecimento_w,
	nr_interno_conta_w
from	lote_auditoria a,
	lote_audit_hist b,
	lote_audit_hist_guia c,
	lote_audit_hist_item d
where	b.nr_seq_lote_audit	= a.nr_sequencia
and	b.nr_sequencia		= c.nr_seq_lote_hist
and	c.nr_sequencia		= nr_seq_hist_item_p
and	d.vl_amenor 		> 0; --somente o que tiver valor para reapresentar.
select	coalesce(max(ie_proc_tuss), 'N'),
	coalesce(max(ie_desc_proc_interno), 'N'),
	coalesce(max(ie_data_rec_glosa_tiss),'P')
into STRICT	ie_codigo_tuss_w,
	ie_desc_tuss_w,
	ie_data_rec_glosa_tiss_w
from	tiss_parametros_convenio
where	cd_convenio		= cd_convenio_w
and	cd_estabelecimento	= cd_estabelecimento_w;

ie_motivo_glosa_conv_w := obter_param_usuario(69, 79, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_motivo_glosa_conv_w);

open C01;
loop
fetch C01 into
	nr_seq_lote_hist_item_w,
	nr_seq_propaci_w,
	nr_seq_matpaci_w,
	cd_motivo_glosa_w,
	vl_amenor_w,
	ds_justificativa_w,
	cd_motivo_glosa_tiss_w,
	nr_seq_ret_glosa_w,
	nr_interno_conta_item_w,
	cd_autorizacao_w,
	ie_funcao_medico_w,
	nr_sequencia_item_w,
	nr_seq_partic_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	it := 0;
	
	if (coalesce(ie_funcao_medico_w::text, '') = '' and (nr_seq_propaci_w IS NOT NULL AND nr_seq_propaci_w::text <> '')) then
		if (nr_seq_partic_w IS NOT NULL AND nr_seq_partic_w::text <> '') then
			 ie_funcao_medico_w := obter_funcao_medico_partic(nr_seq_propaci_w,nr_seq_partic_w);
		end if;
		
		if ( coalesce(ie_funcao_medico_w::text, '') = '') then
			select max(ie_funcao_medico)
			into STRICT ie_funcao_medico_w
			from procedimento_paciente
			where nr_sequencia = nr_seq_propaci_w;
		end if;		
	end if;

	if (coalesce(ie_motivo_glosa_conv_w,'N') = 'S') and (cd_motivo_glosa_tiss_w IS NOT NULL AND cd_motivo_glosa_tiss_w::text <> '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_motivo_glosa_w
		from	tiss_motivo_glosa
		where	cd_motivo_tiss			= cd_motivo_glosa_tiss_w;			
	else
	
		if (coalesce(cd_motivo_glosa_w::text, '') = '') then		
			CALL wheb_mensagem_pck.exibir_mensagem_abort(125738,'NR_SEQ_HIST_ITEM='||nr_seq_hist_item_p);
		end if;
		
		select	max(nr_sequencia)
		into STRICT	nr_seq_motivo_glosa_w
		from	tiss_motivo_glosa
		where	cd_motivo_glosa	= cd_motivo_glosa_w
		and	coalesce(cd_convenio,cd_convenio_w)	= cd_convenio_w;

		if (coalesce(nr_seq_motivo_glosa_w::text, '') = '') then

			select	substr(ds_motivo_glosa,1,200)
			into STRICT	ds_motivo_glosa_w
			from	motivo_glosa
			where	cd_motivo_glosa	= cd_motivo_glosa_w;
			/* Motivo de glosa nao vinculado ao motivo de glosa TISS.
			Verifique o cadastro TISS - Motivos de Glosa, se existe um motivo de glosa TISS vinculado ao motivo de glosa #@DS_MOTIVO_GLOSA_W#@ */
			CALL wheb_mensagem_pck.exibir_mensagem_abort(251407,'DS_MOTIVO_GLOSA_W='||cd_motivo_glosa_w||'-'||ds_motivo_glosa_w);

		end if;
	end if;

	/*Buscar dados do procedimento*/

	if (nr_seq_propaci_w IS NOT NULL AND nr_seq_propaci_w::text <> '') then

		cd_procedimento_tiss_w := null;

		select	max(a.cd_procedimento),
			max(a.ie_origem_proced),
			max(a.cd_procedimento_tuss),
			max(a.ds_proc_tiss),
			max(a.nr_seq_proc_interno),
			max(a.nr_seq_exame),
			max(a.cd_procedimento_convenio),
			max(obter_se_pacote(a.nr_sequencia, a.nr_seq_proc_pacote)),
			max(a.dt_procedimento),
			max(a.nr_seq_tiss_tabela),
			max(a.cd_edicao_amb),
			max(b.cd_categoria_parametro),
			max(a.nr_seq_proc_pacote),
			max(b.nr_atendimento),
			max(a.ie_tiss_tipo_guia),
			max(a.dt_conta)
		into STRICT	cd_procedimento_w,
			ie_origem_proced_w,
			cd_procedimento_tuss_w,
			ds_proc_tiss_w,
			nr_seq_proc_interno_w,
			nr_seq_exame_w,
			cd_procedimento_convenio_w,
			ie_proc_pacote_w,
			dt_procedimento_w,
			nr_seq_tiss_tabela_w,
			cd_edicao_amb_proc_w,
			cd_categoria_parametro_w,
			nr_seq_proc_pacote_w,
			nr_atendimento_w,
			ie_tiss_tipo_guia_w,
			dt_conta_w
		from	procedimento_paciente a,
			conta_paciente b
		where	a.nr_interno_conta	= b.nr_interno_conta
		and	a.nr_sequencia		= nr_seq_propaci_w;
		
		select	substr(obter_desc_procedimento(cd_procedimento_w, ie_origem_proced_w),1,255)
		into STRICT	ds_procedimento_w
		;

		if (coalesce(cd_procedimento_tuss_w,'0') <> '0') then
			open c02;
			loop
			fetch c02 into
				ie_codigo_tuss_w,
				ie_desc_tuss_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				ie_codigo_tuss_w	:= ie_codigo_tuss_w;
				ie_desc_tuss_w		:= ie_desc_tuss_w;
			end loop;
			close c02;
		end if;

		/*definir a descricao do procedimento conforme parametros TISS*/

		if (ie_desc_tuss_w = 'S') then
			select	substr(tiss_eliminar_caractere(coalesce(coalesce(tiss_obter_desc_proc_interno(cd_procedimento_w,
												ie_origem_proced_w,
												nr_seq_proc_interno_w,
												nr_seq_exame_w), ds_proc_tiss_w),
												ds_procedimento_w)),1,150)
			into STRICT	ds_procedimento_w
			;
		elsif (ie_desc_tuss_w = 'P') then
			ds_procedimento_w	:= substr(tiss_eliminar_caractere(coalesce(coalesce(ds_proc_tiss_w, ds_procedimento_w), obter_descricao_procedimento(cd_procedimento_w, ie_origem_proced_w))),1,150);
		elsif (ie_desc_tuss_w = 'T') and (coalesce(cd_procedimento_tuss_w,'0') <> '0') then
			ds_procedimento_w	:= substr(tiss_eliminar_caractere(coalesce(obter_descricao_procedimento(cd_procedimento_tuss_w, '8'),coalesce(ds_proc_tiss_w, ds_procedimento_w))),1,150);
		elsif (ie_desc_tuss_w = 'C')	then
			select	substr(obter_desc_procedimento(cd_procedimento_w,ie_origem_proced_w),1,255)
			into STRICT	ds_proc_tabela_w
			;

			if (ds_procedimento_w = ds_proc_tabela_w) and --Se for igual, nao possui conversao
				(coalesce(cd_procedimento_tuss_w,'0') <> '0') then --Possui proc TUSS
				ds_procedimento_w	:= substr(tiss_eliminar_caractere(coalesce(obter_descricao_procedimento(cd_procedimento_tuss_w, '8'), coalesce(ds_proc_tiss_w, ds_procedimento_w))),1,150);
			end if;
		end if;

		--Obter a descricao se existir cadastrada na regra de tabela proc
		ds_procedimento_w	:= coalesce(TISS_OBTER_TABELA(cd_edicao_amb_proc_w,cd_estabelecimento_w,cd_convenio_w,
								cd_categoria_parametro_w,dt_procedimento_w,'D',
								null,cd_procedimento_w,ie_origem_proced_w,nr_seq_propaci_w,
								nr_seq_proc_pacote_w,nr_atendimento_w,nr_seq_proc_interno_w,
								nr_seq_exame_w, cd_procedimento_tuss_w),
								ds_procedimento_w);

		/*Definir o codigo do procedimento conforme parametros do TISS*/

		
		if (cd_procedimento_tuss_w = 0) then
			cd_procedimento_tuss_w := null;
		end if;
		
		if (ie_codigo_tuss_w = 'S') and (coalesce(cd_procedimento_tuss_w,'0') <> '0') then --Se tem TUSS.
			cd_procedimento_tiss_w	:= coalesce(cd_procedimento_tuss_w,cd_procedimento_convenio_w);

		elsif (ie_codigo_tuss_w = 'S') and (coalesce(cd_procedimento_tuss_w,'0') = '0') then --Se esta para enviar o TUSS, porem o item nao tem TUSS, entao pega a conversao.
			cd_procedimento_tiss_w	:= cd_procedimento_convenio_w;

		elsif (ie_codigo_tuss_w = 'P') and (ie_proc_pacote_w <> 'S') then
			cd_procedimento_tiss_w	:= coalesce(cd_procedimento_tuss_w,cd_procedimento_convenio_w);

		elsif (ie_codigo_tuss_w	= 'C') then
			if (coalesce(cd_procedimento_convenio_w,'0') <> '0') and (cd_procedimento_convenio_w <> cd_procedimento_w) then --Conversao
				cd_procedimento_tiss_w	:= cd_procedimento_convenio_w;

			elsif	(((coalesce(cd_procedimento_convenio_w,'0') = '0') or (cd_procedimento_convenio_w = cd_procedimento_w)) and --Proc TUSS
				 (coalesce(cd_procedimento_tuss_w,'0') <> '0'))  then
				cd_procedimento_tiss_w	:= cd_procedimento_tuss_w;

			elsif	((coalesce(cd_procedimento_tuss_w,'0') = '0') and --Sem Conversao e Sem Proc TUSS
				 (cd_procedimento_convenio_w = cd_procedimento_w)) then
				cd_procedimento_tiss_w	:=  cd_procedimento_w;
			end if;
		end if;

		--Obter o codigo de conversao se existir cadastrada na regra de tabela proc, que tem prioridade sobre os demais.
		cd_procedimento_tiss_w	:= coalesce(TISS_OBTER_TABELA(cd_edicao_amb_proc_w,cd_estabelecimento_w,cd_convenio_w,
								cd_categoria_parametro_w,dt_procedimento_w,'C',
								null,cd_procedimento_w,ie_origem_proced_w,nr_seq_propaci_w,
								nr_seq_proc_pacote_w,nr_atendimento_w,nr_seq_proc_interno_w,
								nr_seq_exame_w, cd_procedimento_tuss_w),
								cd_procedimento_tiss_w);

		cd_procedimento_tiss_w := coalesce(cd_procedimento_tiss_w,cd_procedimento_w);
		
		/*P - Data do movimento no Retorno convenio / Data guia TISS da conta / Data do item na conta,
		  M - Data do movimento no Retorno convenio / data do item na conta
		  C - Data do item na conta
		  T - data guia TISS da conta / Data do item na conta*/
		
		
		if (coalesce(ie_data_rec_glosa_tiss_w,'P') = 'P') then
		
			if (nr_seq_ret_glosa_w IS NOT NULL AND nr_seq_ret_glosa_w::text <> '') then
				
				--select	nvl(tiss_obter_data_item_movto(nr_seq_ret_glosa_w),dt_procedimento_w)
				select	tiss_obter_data_item_movto(nr_seq_ret_glosa_w)
				into STRICT	dt_procedimento_w
				;
				
				if (coalesce(dt_procedimento_w::text, '') = '') then
					if (ie_tiss_tipo_guia_w = '7') then
						select	coalesce(max(a.dt_item),dt_procedimento_w),
							coalesce(max(coalesce(a.dt_final, tiss_obter_se_hora(coalesce(a.dt_hora_item, a.dt_item)))),dt_procedimento_w)
						into STRICT	dt_procedimento_w,
							dt_fim_procedimento_w
						from	tiss_conta_desp a
						where	a.nr_interno_conta				= nr_interno_conta_w
						and (a.cd_procedimento 				= cd_procedimento_tiss_w or
							ltrim(a.cd_procedimento,'0') 	= cd_procedimento_tiss_w);
					else	
					select	coalesce(max(coalesce(a.dt_inicio_cir,a.dt_procedimento)),dt_procedimento_w),
						max(coalesce(a.dt_fim_cir,a.dt_procedimento))
					into STRICT	dt_procedimento_w,
						dt_fim_procedimento_w
					from	tiss_conta_proc a
					where	a.nr_interno_conta 	= nr_interno_conta_w
					and (a.cd_procedimento 		= cd_procedimento_tiss_w or
						ltrim(a.cd_procedimento,'0') 	= cd_procedimento_tiss_w);			
					end if;
				end if;
				
				dt_fim_procedimento_w	:= dt_procedimento_w;			
			else		
				if (ie_tiss_tipo_guia_w = '7') then
					select	coalesce(max(a.dt_item),dt_procedimento_w),
						coalesce(max(coalesce(a.dt_final, tiss_obter_se_hora(coalesce(a.dt_hora_item, a.dt_item)))),dt_procedimento_w)
					into STRICT	dt_procedimento_w,
						dt_fim_procedimento_w
					from	tiss_conta_desp a
					where	a.nr_interno_conta		= nr_interno_conta_w
					and (a.cd_procedimento 		= cd_procedimento_tiss_w or
						ltrim(a.cd_procedimento,'0') 	= cd_procedimento_tiss_w);
				else	
					select	coalesce(max(coalesce(a.dt_inicio_cir,a.dt_procedimento)),dt_procedimento_w),
						max(coalesce(a.dt_fim_cir,a.dt_procedimento))
					into STRICT	dt_procedimento_w,
						dt_fim_procedimento_w
					from	tiss_conta_proc a
					where	a.nr_interno_conta 	= nr_interno_conta_w
					and (a.cd_procedimento 		= cd_procedimento_tiss_w or
						ltrim(a.cd_procedimento,'0') 	= cd_procedimento_tiss_w);			
				end if;
			end if;
		elsif (coalesce(ie_data_rec_glosa_tiss_w,'P') = 'M') then
		
			if (nr_seq_ret_glosa_w IS NOT NULL AND nr_seq_ret_glosa_w::text <> '') then
				
				select	tiss_obter_data_item_movto(nr_seq_ret_glosa_w)
				into STRICT	dt_procedimento_w
				;
				
				if (coalesce(dt_procedimento_w::text, '') = '') then
					if (ie_tiss_tipo_guia_w = '7') then
						select	coalesce(max(a.dt_item),dt_procedimento_w),
							coalesce(max(coalesce(a.dt_final, tiss_obter_se_hora(coalesce(a.dt_hora_item, a.dt_item)))),dt_procedimento_w)
						into STRICT	dt_procedimento_w,
							dt_fim_procedimento_w
						from	tiss_conta_desp a
						where	a.nr_interno_conta				= nr_interno_conta_w
						and (a.cd_procedimento 				= cd_procedimento_tiss_w or
							ltrim(a.cd_procedimento,'0') 	= cd_procedimento_tiss_w);
					else	
					select	coalesce(max(coalesce(a.dt_inicio_cir,a.dt_procedimento)),dt_procedimento_w),
						max(coalesce(a.dt_fim_cir,a.dt_procedimento))
					into STRICT	dt_procedimento_w,
						dt_fim_procedimento_w
					from	tiss_conta_proc a
					where	a.nr_interno_conta 	= nr_interno_conta_w
					and (a.cd_procedimento 		= cd_procedimento_tiss_w or
						ltrim(a.cd_procedimento,'0') 	= cd_procedimento_tiss_w);			
					end if;
				end if;
				
				dt_fim_procedimento_w	:= dt_procedimento_w;			
			end if;
		elsif (coalesce(ie_data_rec_glosa_tiss_w,'P') = 'T') then
		
			if (ie_tiss_tipo_guia_w = '7') then
				select	coalesce(max(a.dt_item),dt_procedimento_w),
					coalesce(max(coalesce(a.dt_final, tiss_obter_se_hora(coalesce(a.dt_hora_item, a.dt_item)))),dt_procedimento_w)
				into STRICT	dt_procedimento_w,
					dt_fim_procedimento_w
				from	tiss_conta_desp a
				where	a.nr_interno_conta		= nr_interno_conta_w
				and (a.cd_procedimento 		= cd_procedimento_tiss_w or
					ltrim(a.cd_procedimento,'0') 	= cd_procedimento_tiss_w);
			else	
				select	coalesce(max(coalesce(a.dt_inicio_cir,a.dt_procedimento)),dt_procedimento_w),
					max(coalesce(a.dt_fim_cir,a.dt_procedimento))
				into STRICT	dt_procedimento_w,
					dt_fim_procedimento_w
				from	tiss_conta_proc a
				where	a.nr_interno_conta 	= nr_interno_conta_w
				and (a.cd_procedimento 		= cd_procedimento_tiss_w or
					ltrim(a.cd_procedimento,'0') 	= cd_procedimento_tiss_w);			
			end if;
		elsif (coalesce(ie_data_rec_glosa_tiss_w,'P') = 'S') then
		
			dt_procedimento_w	:= coalesce(dt_conta_w,dt_procedimento_w);
			dt_fim_procedimento_w	:= dt_procedimento_w;
		
		end if;
		
		if (ie_tiss_tipo_guia_w in ('7','8','9')) then
				select	coalesce(max(a.cd_procedimento),cd_procedimento_tiss_w)
				into STRICT	cd_procedimento_tiss_w
				from	tiss_conta_desp a
				where	a.nr_interno_conta		= nr_interno_conta_w
				and (a.cd_procedimento 		= cd_procedimento_tiss_w or
					ltrim(a.cd_procedimento,'0') 	= cd_procedimento_tiss_w);
		else	
				select	coalesce(max(a.cd_procedimento),cd_procedimento_tiss_w)
				into STRICT	cd_procedimento_tiss_w
				from	tiss_conta_proc a
				where	a.nr_interno_conta 		= nr_interno_conta_w
				and (a.cd_procedimento 		= cd_procedimento_tiss_w or
					ltrim(a.cd_procedimento,'0') 	= cd_procedimento_tiss_w);
		end if;
		
        if (tiss_itens_recurso_w.count > 0) then
		for it in tiss_itens_recurso_w.first .. tiss_itens_recurso_w.last loop
			if(tiss_itens_recurso_w[it].cd_autorizacao = cd_autorizacao_w and
				tiss_itens_recurso_w[it].cd_procedimento = cd_procedimento_tiss_w and
				tiss_itens_recurso_w[it].nr_interno_conta  = nr_interno_conta_item_w and
				trunc(tiss_itens_recurso_w[it].dt_item, DAY_C) = trunc(dt_procedimento_w, DAY_C) and
				tiss_itens_recurso_w[it].ie_item_adicionado = 'N' and
        (((nr_sequencia_item_w IS NOT NULL AND nr_sequencia_item_w::text <> '') and nr_sequencia_item_w = tiss_itens_recurso_w[it].nr_sequencia_item) or (coalesce(nr_sequencia_item_w::text, '') = ''))) then

				nr_sequencia_item_w := tiss_itens_recurso_w[it].nr_sequencia_item;
				tiss_itens_recurso_w[it].ie_item_adicionado := 'S';
				EXIT;
			end if;
		end loop;
        end if;
	
	/*Buscar dados do material*/

	elsif (nr_seq_matpaci_w IS NOT NULL AND nr_seq_matpaci_w::text <> '') then

		select	max(cd_material),
			max(dt_atendimento),
			max(coalesce(cd_material_tiss,cd_material)),
			coalesce(max(ds_material_tiss),max(obter_desc_material(cd_material))),
			max(nr_seq_tiss_tabela),
			max(ie_tiss_tipo_guia_desp),
			max(dt_conta)
		into STRICT	cd_material_w,
			dt_procedimento_w,
			cd_procedimento_tiss_w,
			ds_procedimento_w,
			nr_seq_tiss_tabela_w,
			ie_tiss_tipo_guia_w,
			dt_conta_w
		from	material_atend_paciente
		where	nr_sequencia	= nr_seq_matpaci_w;
		
		/*P - Data do movimento no Retorno convenio / Data guia TISS da conta / Data do item na conta,
		  M - Data do movimento no Retorno convenio / data do item na conta
		  C - Data do item na conta
		  T - data guia TISS da conta / Data do item na conta*/
		if (coalesce(ie_data_rec_glosa_tiss_w,'P') = 'P') then
			if (nr_seq_ret_glosa_w IS NOT NULL AND nr_seq_ret_glosa_w::text <> '') then
				select	tiss_obter_data_item_movto(nr_seq_ret_glosa_w)
				into STRICT	dt_procedimento_w
				;
				
				if (coalesce(dt_procedimento_w::text, '') = '') then
					select	coalesce(max(a.dt_item),dt_procedimento_w),
						coalesce(max(coalesce(a.dt_final, tiss_obter_se_hora(coalesce(a.dt_hora_item, a.dt_item)))),dt_procedimento_w)
					into STRICT	dt_procedimento_w,
						dt_fim_procedimento_w
					from	tiss_conta_desp a
					where	a.nr_interno_conta				= nr_interno_conta_w
					and (a.cd_procedimento 				= cd_procedimento_tiss_w or
						ltrim(a.cd_procedimento,'0') 	= cd_procedimento_tiss_w);
				end if;
				
				dt_fim_procedimento_w	:= dt_procedimento_w;
			else
				--Obter a data enviada para o item na cobranca da guia		
				select	coalesce(max(a.dt_item),dt_procedimento_w),
					coalesce(max(coalesce(a.dt_final, tiss_obter_se_hora(coalesce(a.dt_hora_item, a.dt_item)))),dt_procedimento_w)
				into STRICT	dt_procedimento_w,
					dt_fim_procedimento_w
				from	tiss_conta_desp a
				where	a.nr_interno_conta		= nr_interno_conta_w
				and (a.cd_procedimento 		= cd_procedimento_tiss_w or
					ltrim(a.cd_procedimento,'0') 	= cd_procedimento_tiss_w);
			end if;
		elsif (coalesce(ie_data_rec_glosa_tiss_w,'P') = 'M') then
		
			if (nr_seq_ret_glosa_w IS NOT NULL AND nr_seq_ret_glosa_w::text <> '') then
				select	tiss_obter_data_item_movto(nr_seq_ret_glosa_w)
				into STRICT	dt_procedimento_w
				;
				
				if (coalesce(dt_procedimento_w::text, '') = '') then
					select	coalesce(max(a.dt_item),dt_procedimento_w),
						coalesce(max(coalesce(a.dt_final, tiss_obter_se_hora(coalesce(a.dt_hora_item, a.dt_item)))),dt_procedimento_w)
					into STRICT	dt_procedimento_w,
						dt_fim_procedimento_w
					from	tiss_conta_desp a
					where	a.nr_interno_conta				= nr_interno_conta_w
					and (a.cd_procedimento 				= cd_procedimento_tiss_w or
						ltrim(a.cd_procedimento,'0') 			= cd_procedimento_tiss_w);
				end if;
				
				dt_fim_procedimento_w	:= dt_procedimento_w;
			end if;
		elsif (coalesce(ie_data_rec_glosa_tiss_w,'P') = 'T') then

			select	coalesce(max(a.dt_item),dt_procedimento_w),
				coalesce(max(coalesce(a.dt_final, tiss_obter_se_hora(coalesce(a.dt_hora_item, a.dt_item)))),dt_procedimento_w)
			into STRICT	dt_procedimento_w,
				dt_fim_procedimento_w
			from	tiss_conta_desp a
			where	a.nr_interno_conta		= nr_interno_conta_w
			and (a.cd_procedimento 		= cd_procedimento_tiss_w or
				ltrim(a.cd_procedimento,'0') 	= cd_procedimento_tiss_w);
		elsif (coalesce(ie_data_rec_glosa_tiss_w,'P') = 'S') then
							
			dt_procedimento_w	:= coalesce(dt_conta_w,dt_procedimento_w);
			dt_fim_procedimento_w	:= dt_procedimento_w;
		end if;

		cd_procedimento_w		:= null;
		ie_origem_proced_w	:= null;
		
		select	coalesce(max(a.cd_procedimento),cd_procedimento_tiss_w)
		into STRICT	cd_procedimento_tiss_w
		from	tiss_conta_desp a
		where	a.nr_interno_conta	= nr_interno_conta_w
		and (a.cd_procedimento 	= cd_procedimento_tiss_w or
		ltrim(a.cd_procedimento,'0') 	= cd_procedimento_tiss_w);

        if (tiss_itens_recurso_w.count > 0) then
		for it in tiss_itens_recurso_w.first .. tiss_itens_recurso_w.last loop            
			if( tiss_itens_recurso_w[it].cd_autorizacao = cd_autorizacao_w and
				tiss_itens_recurso_w[it].cd_procedimento = cd_procedimento_tiss_w and
				tiss_itens_recurso_w[it].nr_interno_conta  = nr_interno_conta_item_w and
				trunc(tiss_itens_recurso_w[it].dt_item, DAY_C) = trunc(dt_procedimento_w, DAY_C) and
				tiss_itens_recurso_w[it].ie_item_adicionado = 'N' and 
        (((nr_sequencia_item_w IS NOT NULL AND nr_sequencia_item_w::text <> '') and nr_sequencia_item_w = tiss_itens_recurso_w[it].nr_sequencia_item) or (coalesce(nr_sequencia_item_w::text, '') = '') )) then

				nr_sequencia_item_w := tiss_itens_recurso_w[it].nr_sequencia_item;
				tiss_itens_recurso_w[it].ie_item_adicionado := 'S';
				EXIT;
			end if;
		end loop;
        end if;

	end if;

	select	max(cd_tabela_xml)
	into STRICT	cd_edicao_amb_w
	from	tiss_tipo_tabela
	where	nr_sequencia	= nr_seq_tiss_tabela_w;

	ds_procedimento_w	:= substr(ds_procedimento_w,1,150); -- No TISS permite somente 150 caracteres
	cd_procedimento_tiss_w	:= substr(cd_procedimento_tiss_w,1,10); --No TISS permite somente 10 caracteres
	insert into tiss_recurso_glosa_item(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_lote_hist_item,
		nr_seq_rec_guia,
		nr_seq_propaci,
		nr_seq_matpaci,
		dt_procedimento,
		dt_fim_procedimento,
		cd_material,
		cd_procedimento,
		ie_origem_proced,
		cd_procedimento_convenio,
		cd_edicao_amb,
		ds_procedimento,
		nr_seq_motivo_glosa,
		vl_recursado,
		ds_justificativa,
		ie_funcao_medico,
		nr_sequencia_item)
	values (nextval('tiss_recurso_glosa_item_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_lote_hist_item_w,
		nr_seq_rec_guia_p,
		nr_seq_propaci_w,
		nr_seq_matpaci_w,
		dt_procedimento_w,
		coalesce(dt_fim_procedimento_w,dt_procedimento_w),
		cd_material_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		cd_procedimento_tiss_w,
		cd_edicao_amb_w,
		tiss_eliminar_caractere(ds_procedimento_w),
		nr_seq_motivo_glosa_w,
		vl_amenor_w,
		tiss_eliminar_caractere(ds_justificativa_w),
		Lpad(tiss_obter_grau_partic(ie_funcao_medico_w),2,'0'),
		nr_sequencia_item_w);

	end;
end loop;
close C01;

tiss_itens_recurso_w.delete;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_gerar_recurso_glosa_item (nr_seq_hist_item_p bigint, nm_usuario_p text, nr_seq_rec_guia_p bigint) FROM PUBLIC;

