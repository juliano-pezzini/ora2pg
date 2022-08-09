-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_repasse_interv_producao ( nr_repasse_terceiro_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade:  Gerar repasses especiais com base no intervalo de produção do Médico(Plantões/Escalas de plantões) 
---------------------------------------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[X] Objetos do dicionário [X] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ---------------------------------------------------------------------------------------------------------------------------------------------------- 
Pontos de atenção: 
 - Rotina excutada no (Delphi/Java) dentro do FatAct_FF 
 - Rotina executada dentro da Procedure GERAR_REPASSE_TERCEIRO 
------------------------------------------------------------------------------------------------------------------- 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
*/ 
 
--Variáveis do repasse 
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
nr_seq_terceiro_w		terceiro.nr_sequencia%type;
dt_periodo_inicial_w		repasse_terceiro.dt_periodo_inicial%type;
dt_periodo_final_w		repasse_terceiro.dt_periodo_final%type;

--Variáveis para manipulação no Insert 
nr_seq_rep_terc_item_w		repasse_terceiro_item.nr_sequencia%type;
nr_sequencia_item_w		repasse_terceiro_item.nr_sequencia_item%type;
vl_repasse_pago_w		repasse_terceiro_item.vl_repasse%type;

--Variáveis para realizar tratamento do valor a ser inserido 
qt_procedimento_w		integer;
vl_repasse_temp_w		repasse_terceiro_item.vl_repasse%type;

--Manipulação das datas para a tolerância do Plantão 
dt_inicio_plantao_w	timestamp;
dt_fim_plantao_w	timestamp;

--Obtém as pessoas vinculadas ao terceiro 
c_pessoas_terc CURSOR(	nr_seq_terceiro_pc	terceiro.nr_sequencia%type, 
			dt_periodo_final_pc	timestamp) FOR 
	SELECT	a.cd_pessoa_fisica 
	from	terceiro a 
	where	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '') 
	and	a.nr_sequencia		= nr_seq_terceiro_pc 
	and	coalesce(a.dt_fim_vigencia,dt_periodo_final_pc) >= dt_periodo_final_pc 
	
union
 
	SELECT	a.cd_pessoa_fisica 
	from	terceiro_pessoa_fisica a 
	where	a.nr_seq_terceiro	= nr_seq_terceiro_pc 
	and	coalesce(a.dt_fim_vigencia,dt_periodo_final_pc) >= dt_periodo_final_pc;

--Obtém os dados dos plantões/escalas 
c_plantao_escala CURSOR(	dt_periodo_inicial_pc	timestamp, 
				dt_periodo_final_pc	timestamp, 
				cd_medico_pc		pessoa_fisica.cd_pessoa_fisica%type) FOR 
	SELECT (a.qt_minuto / 60) qt_hora, 
		a.dt_inicial dt_inicial, 
		a.dt_final dt_final, 
		null nr_seq_escala, 
		null ie_tipo_escala 
	from	medico_plantao a 
	where	a.dt_inicial	between dt_periodo_inicial_pc and dt_periodo_final_pc 
	and	a.cd_medico	= cd_medico_pc 
	
union	all
 
	PERFORM	(((a.dt_fim-a.dt_inicio)*86400)/3600) qt_hora, 
		a.dt_inicio dt_inicial, 
		a.dt_fim dt_final, 
		a.nr_seq_escala, 
		(select	max(x.ie_tipo) 
		from	escala x 
		where	x.nr_sequencia = a.nr_seq_escala) ie_tipo_escala 
	from	escala_diaria a 
	where	a.dt_inicio between dt_periodo_inicial_pc and dt_periodo_final_pc 
	and	a.cd_pessoa_fisica = cd_medico_pc;

--Obtém os dados da regra de intervalo de produção 
c_regra_int_prod CURSOR(	cd_medico_pc		pessoa_fisica.cd_pessoa_fisica%type, 
				nr_seq_terceiro_pc	terceiro.nr_sequencia%type, 
				qt_hora_pc		bigint, 
				cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type, 
				ie_tipo_escala_pc	escala.ie_tipo%type, 
				nr_seq_escala_pc	escala.nr_sequencia%type) FOR 
	SELECT	a.ie_limpar_itens, 
		a.ds_observacao, 
		a.nr_sequencia, 
		a.qt_min_tolerancia 
	from	regra_intervalo_producao a 
	where	coalesce(a.cd_medico,cd_medico_pc)			= cd_medico_pc 
	and	coalesce(a.nr_seq_terceiro,nr_seq_terceiro_pc)	= nr_seq_terceiro_pc 
	and	qt_hora_pc		between coalesce(a.qt_min_hora,qt_hora_pc) and coalesce(a.qt_max_hora,qt_hora_pc) 
	and	trunc(clock_timestamp(),'dd')	between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia,clock_timestamp()) 
	and	a.cd_estabelecimento	= cd_estabelecimento_pc 
	and (coalesce(a.ie_tipo_escala::text, '') = '' or a.ie_tipo_escala 	= ie_tipo_escala_pc) 
	and (coalesce(a.nr_seq_escala::text, '') = '' or a.nr_seq_escala	= nr_seq_escala_pc);

--Obtém os dados do critério de intervalo de produção 
c_criterio_int_prod CURSOR(	nr_seq_regra_interv_pc	regra_interv_prod_criterio.nr_seq_regra_interv%type) FOR 
	SELECT	a.cd_area_procedimento, 
		a.cd_procedimento, 
		a.ie_origem_proced, 
		a.qt_min_proced, 
		a.cd_especialidade, 
		a.cd_grupo_proc, 
		a.ie_tipo_convenio, 
		a.cd_convenio, 
		a.qt_max_proced, 
		a.nr_sequencia 
	from	regra_interv_prod_criterio a 
	where	a.nr_seq_regra_interv	= nr_seq_regra_interv_pc;

--Obtém os dados do valor de intervalo de produção. 
c_valor_int_prod CURSOR(	nr_seq_regra_crit_pc	regra_interv_prod_valor.nr_seq_regra_crit%type) FOR 
	SELECT	a.cd_convenio, 
		a.cd_procedimento, 
		a.ie_origem_proced, 
		a.tx_repasse, 
		a.vl_repasse, 
		a.ie_repasse, 
		a.ie_valor_oposto, 
		a.nr_seq_trans_financ 
	from	regra_interv_prod_valor a 
	where	a.nr_seq_regra_crit = nr_seq_regra_crit_pc;

BEGIN 
 
--Retorna os dados do repasse que está gerando o intervalo de produção. 
select	max(a.cd_estabelecimento), 
	max(a.dt_periodo_inicial), 
	max(a.dt_periodo_final), 
	max(a.nr_seq_terceiro) 
into STRICT	cd_estabelecimento_w, 
	dt_periodo_inicial_w, 
	dt_periodo_final_w, 
	nr_seq_terceiro_w 
from	repasse_terceiro a 
where	a.nr_repasse_terceiro	= nr_repasse_terceiro_p;
 
--Retorna os médicos vinculados ao terceiro 
for r_c_pessoas_terc in c_pessoas_terc(nr_seq_terceiro_w, dt_periodo_final_w) loop 
 
	--Retorna os dados dos plantões/escalas 
	for r_c_plantao_escala in c_plantao_escala(dt_periodo_inicial_w, dt_periodo_final_w, r_c_pessoas_terc.cd_pessoa_fisica) loop 
	 
		--Retorna os dados da regra de intervalo de produção. 
		for r_c_regra_int_prod in c_regra_int_prod(	r_c_pessoas_terc.cd_pessoa_fisica, nr_seq_terceiro_w, r_c_plantao_escala.qt_hora, cd_estabelecimento_w, 
								r_c_plantao_escala.ie_tipo_escala, r_c_plantao_escala.nr_seq_escala) loop 
								 
			dt_inicio_plantao_w	:= (r_c_plantao_escala.dt_inicial - r_c_regra_int_prod.qt_min_tolerancia /(24*60));
			dt_fim_plantao_w	:= (r_c_plantao_escala.dt_final + r_c_regra_int_prod.qt_min_tolerancia /(24*60));
			 
			--Verifica se deve excluir os itens já gerados. 
			if (coalesce(r_c_regra_int_prod.ie_limpar_itens,'S')	= 'S') then 
 
				delete	from repasse_terceiro_item a 
				where	(a.nr_seq_regra_interv IS NOT NULL AND a.nr_seq_regra_interv::text <> '') 
				and	a.nr_repasse_terceiro	= nr_repasse_terceiro_p;
 
			end if;
			 
			--Retorna os dados do critério do intervalo de produção. 
			for r_c_criterio_int_prod in c_criterio_int_prod(r_c_regra_int_prod.nr_sequencia) loop 
								 
				--Obtém a quantidade de procedimentos executados para a regra. 
				select	count(1) 
				into STRICT	qt_procedimento_w 
				from	convenio d, 
					conta_paciente c, 
					estrutura_procedimento_v b, 
					procedimento_paciente a 
				where	a.ie_origem_proced	= b.ie_origem_proced 
				and	a.cd_procedimento	= b.cd_procedimento 
				and	a.nr_interno_conta	= c.nr_interno_conta 
				and	c.cd_convenio_parametro	= d.cd_convenio 
				and	a.cd_procedimento	= coalesce(r_c_criterio_int_prod.cd_procedimento,a.cd_procedimento) 
				and	a.ie_origem_proced	= coalesce(r_c_criterio_int_prod.ie_origem_proced,a.ie_origem_proced) 
				and	b.cd_area_procedimento	= coalesce(r_c_criterio_int_prod.cd_area_procedimento,b.cd_area_procedimento) 
				and	b.cd_especialidade	= coalesce(r_c_criterio_int_prod.cd_especialidade, b.cd_especialidade) 
				and	b.cd_grupo_proc		= coalesce(r_c_criterio_int_prod.cd_grupo_proc,b.cd_grupo_proc) 
				and	a.dt_procedimento	between dt_inicio_plantao_w and dt_fim_plantao_w 
				and	a.cd_medico_executor	= coalesce(r_c_pessoas_terc.cd_pessoa_fisica,a.cd_medico_executor) 
				and	d.cd_convenio		= coalesce(r_c_criterio_int_prod.cd_convenio,d.cd_convenio) 
				and	d.ie_tipo_convenio	= coalesce(r_c_criterio_int_prod.ie_tipo_convenio,d.ie_tipo_convenio);
				 
				 
				if	(((qt_procedimento_w	>= coalesce(r_c_criterio_int_prod.qt_min_proced,qt_procedimento_w)) and (qt_procedimento_w	<= coalesce(r_c_criterio_int_prod.qt_max_proced,qt_procedimento_w))) or (qt_procedimento_w	> coalesce(r_c_criterio_int_prod.qt_max_proced,qt_procedimento_w))) then 
					 
					--Retorna os dados dos valores do intervalo de produção. 
					for r_c_valor_int_prod in c_valor_int_prod(r_c_criterio_int_prod.nr_sequencia) loop 
					 
						--Obtém os valores de repasse 
						if (qt_procedimento_w <> 0) or (r_c_valor_int_prod.ie_repasse not in ('E','N')) then 
							vl_repasse_pago_w	:= 0;
							vl_repasse_temp_w	:= 0;
							 
							--Verifica se deve obter os valores do procedimento 
							if (coalesce(r_c_valor_int_prod.tx_repasse,0) <> 0) then 
							 
							vl_repasse_temp_w	:=	Obter_preco_proced( 
												cd_estabelecimento_w, 
												r_c_valor_int_prod.cd_convenio, 
												null, 
												clock_timestamp(), 
												r_c_valor_int_prod.cd_procedimento, 
												r_c_valor_int_prod.ie_origem_proced, 
												null, 
												null, 
												null, 
												null, 
												null, 
												null, 
												null, 
												null, 
												null, 
												'P', 
												null, 
												null);
							 
							 
							vl_repasse_temp_w	:= ((coalesce(vl_repasse_temp_w,0) * r_c_valor_int_prod.tx_repasse)/100);
							 
							end if;
							 
							--Verifica se o valor do procedimento é fixo. Caso sim, este valor é informado na regra. 
							if (coalesce(r_c_valor_int_prod.vl_repasse,0) <> 0) then 
								vl_repasse_temp_w := r_c_valor_int_prod.vl_repasse;	
							end if;
							 
							--Verifica qual a forma de calcular o valor de acordo com a forma de repasse informada na regra 
							if (r_c_valor_int_prod.ie_repasse	= 'U') and (vl_repasse_pago_w = 0) then 
								vl_repasse_pago_w	:= vl_repasse_temp_w;
							elsif (r_c_valor_int_prod.ie_repasse = 'P') then 
								vl_repasse_pago_w	:= (vl_repasse_temp_w * qt_procedimento_w);
							elsif (r_c_valor_int_prod.ie_repasse = 'E') then 
								qt_procedimento_w	:= (qt_procedimento_w - r_c_criterio_int_prod.qt_max_proced);
								vl_repasse_pago_w	:= (vl_repasse_temp_w * qt_procedimento_w);
							elsif (r_c_valor_int_prod.ie_repasse = 'N') then 
								qt_procedimento_w	:= (qt_procedimento_w - (qt_procedimento_w - r_c_criterio_int_prod.qt_max_proced));
								vl_repasse_pago_w	:= (vl_repasse_temp_w * qt_procedimento_w);
							end if;
							 
							--Insere o registro caso o vlaor seja diferente de zero 
							if (coalesce(vl_repasse_pago_w,0) <> 0) then 
								 
								select	nextval('repasse_terceiro_item_seq') 
								into STRICT	nr_seq_rep_terc_item_w 
								;
								 
								select	coalesce(max(nr_sequencia_item),0) + 1 
								into STRICT	nr_sequencia_item_w 
								from	repasse_terceiro_item 
								where	nr_repasse_terceiro = nr_repasse_terceiro_p;
								 
								insert	into repasse_terceiro_item(nr_sequencia, 
									dt_atualizacao, 
									nm_usuario, 
									vl_repasse, 
									cd_convenio, 
									cd_procedimento, 
									ie_origem_proced, 
									dt_lancamento, 
									nr_sequencia_item, 
									nr_seq_terceiro, 
									ds_observacao, 
									cd_medico, 
									nr_repasse_terceiro, 
									nr_seq_regra_interv, 
									dt_plantao, 
									nr_seq_trans_fin_prov) 
								values (nr_seq_rep_terc_item_w, 
									clock_timestamp(), 
									nm_usuario_p, 
									CASE WHEN r_c_valor_int_prod.ie_valor_oposto='S' THEN (vl_repasse_pago_w*-1)  ELSE vl_repasse_pago_w END , 
									r_c_valor_int_prod.cd_convenio, 
									r_c_valor_int_prod.cd_procedimento, 
									r_c_valor_int_prod.ie_origem_proced, 
									dt_periodo_final_w, 
									nr_sequencia_item_w, 
									nr_seq_terceiro_w, 
									r_c_regra_int_prod.ds_observacao, 
									r_c_pessoas_terc.cd_pessoa_fisica, 
									nr_repasse_terceiro_p, 
									r_c_regra_int_prod.nr_sequencia, 
									r_c_plantao_escala.dt_inicial, 
									r_c_valor_int_prod.nr_seq_trans_financ);
							end if;
						end if;	
						 
					--Fim do loop do cursor c_valor_int_prod 
					end loop;
				end if;
				 
			--Fim do loop do cursor c_criterio_int_prod 
			end loop;
			 
		--Fim do loop do cursor c_regra_int_prod 
		end loop;
	 
	--Fim do loop do cursor c_plantao_escala 
	end loop;
	 
--Fim do loop do cursor c_pessoas_terc 
end loop;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_repasse_interv_producao ( nr_repasse_terceiro_p bigint, nm_usuario_p text) FROM PUBLIC;
