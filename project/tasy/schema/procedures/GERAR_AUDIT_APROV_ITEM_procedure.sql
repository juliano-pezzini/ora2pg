-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_audit_aprov_item ( nr_seq_auditoria_p bigint, nm_usuario_p text, ie_gerou_aprovacao_p INOUT text) AS $body$
DECLARE


qt_regra_w			bigint;
qt_aprovacao_audit_w		bigint;
qt_aprovacao_audit_ww		bigint;
qt_aprovacao_audit_inicial_w	bigint;
ie_gerou_aprovacao_w		varchar(1) := 'N';
nr_seq_item_w			bigint;
vl_unitario_w			double precision;
dt_item_w			timestamp;
ie_tipo_item_w			varchar(1);
cd_estabelecimento_w		integer;
nr_seq_regra_aprov_w		bigint;
ie_tipo_responsavel_w		varchar(1);
cd_cargo_w			bigint;
nm_usuario_aprov_w		varchar(15);
ie_exige_justificativa_w	varchar(1);
nm_usuario_aprov_regra_w	varchar(15);
nr_nivel_regra_w		smallint;
qt_aprovacao_audit_pend_w	bigint;
qt_aprovacao_audit_aprovado_w	bigint;
qt_aprovacao_audit_novo_w	bigint;	

cd_convenio_w			convenio.cd_convenio%type;
ie_tipo_atendimento_w		atendimento_paciente.ie_tipo_atendimento%type;
cd_setor_atendimento_w		setor_atendimento.cd_setor_atendimento%type;

cd_grupo_proc_mat_w		bigint;
cd_subgrupo_espec_w		bigint;
cd_classe_area_w		bigint;
cd_item_w			bigint;

ie_tipo_ajuste_w		varchar(1):='N';

C01 CURSOR FOR
	SELECT	b.nr_sequencia,
		a.vl_unitario,
		a.dt_atendimento,
		'M' ie_tipo_item,
		m.cd_grupo_material,
		m.cd_subgrupo_material,
		m.cd_classe_material,
		a.cd_material,
		a.cd_setor_atendimento
	from	material_atend_paciente a,
		auditoria_matpaci b,
		estrutura_material_v m
	where	a.nr_sequencia = b.nr_seq_matpaci
	and	m.cd_material  = a.cd_material
	and	b.nr_seq_auditoria = nr_seq_auditoria_p
	and	((ie_tipo_ajuste_w = 'N' and (
					      coalesce(b.qt_ajuste, coalesce(b.qt_original,0)) < coalesce(b.qt_original,0) or (b.ie_tipo_auditoria = 'E' and b.qt_original < 0)
					      )) or (ie_tipo_ajuste_w = 'P' and (
					      coalesce(b.qt_ajuste, coalesce(b.qt_original,0)) > coalesce(b.qt_original,0) or (b.ie_tipo_auditoria = 'E' and b.qt_original > 0)
					      )) or (ie_tipo_ajuste_w = 'A' and (
					      coalesce(b.qt_ajuste, coalesce(b.qt_original,0)) <> coalesce(b.qt_original,0) or (b.ie_tipo_auditoria = 'E')
					      )))
	
union all

	SELECT	b.nr_sequencia,
		dividir(a.vl_procedimento, a.qt_procedimento) vl_unitario,
		a.dt_procedimento,
		'P' ie_tipo_item,
		p.cd_grupo_proc,
		p.cd_especialidade,
		p.cd_area_procedimento,
		p.cd_procedimento,
		a.cd_setor_atendimento
	from	procedimento_paciente a,
		auditoria_propaci b,
		estrutura_procedimento_v p
	where	a.nr_sequencia = b.nr_seq_propaci
	and	b.nr_seq_auditoria = nr_seq_auditoria_p
	and	p.cd_procedimento  = a.cd_procedimento
	and	p.ie_origem_proced = a.ie_origem_proced
	and	((ie_tipo_ajuste_w = 'N' and (
                              coalesce(b.qt_ajuste, coalesce(b.qt_original,0)) < coalesce(b.qt_original,0) or (b.ie_tipo_auditoria = 'E' and b.qt_original < 0)
                              )) or (ie_tipo_ajuste_w = 'P' and (
                              coalesce(b.qt_ajuste, coalesce(b.qt_original,0)) > coalesce(b.qt_original,0) or (b.ie_tipo_auditoria = 'E' and b.qt_original > 0)
                              )) or (ie_tipo_ajuste_w = 'A' and (
                              coalesce(b.qt_ajuste, coalesce(b.qt_original,0)) <> coalesce(b.qt_original,0) or (b.ie_tipo_auditoria = 'E')
                              )));

C02 CURSOR FOR
	SELECT	nr_sequencia,
		ie_tipo_responsavel,
		cd_cargo,
		nm_usuario_aprov,
		ie_exige_justificativa
	from	regra_aprovacao_auditoria
	where	coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_w,0)) = coalesce(cd_estabelecimento_w,0)
	and	dt_item_w between trunc(dt_vigencia_inicial,'dd') and (trunc(coalesce(dt_vigencia_final, dt_item_w),'dd') + 86399/86400)
	and	coalesce(vl_unitario_w,0) between vl_minimo and vl_maximo
	and	ie_situacao = 'A'
	and	coalesce(cd_convenio,cd_convenio_w) 			 = cd_convenio_w
	and	coalesce(ie_tipo_atendimento,ie_tipo_atendimento_w)	 = ie_tipo_atendimento_w
	and	coalesce(cd_setor_atendimento,cd_setor_atendimento_w) = cd_setor_atendimento_w                    
	and	coalesce(cd_area_procedimento,cd_classe_area_w)       = cd_classe_area_w                   
	and	coalesce(cd_especialidade_proc,cd_subgrupo_espec_w)   = cd_subgrupo_espec_w                  
	and	coalesce(cd_grupo_proc,cd_grupo_proc_mat_w)           = cd_grupo_proc_mat_w
	and	coalesce(cd_grupo_material,cd_grupo_proc_mat_w)       = cd_grupo_proc_mat_w                
	and	coalesce(cd_subgrupo_material,cd_subgrupo_espec_w)    = cd_subgrupo_espec_w                   
	and	coalesce(cd_classe_material,cd_classe_area_w)         = cd_classe_area_w                     
	and	coalesce(cd_material,cd_item_w)			 = cd_item_w                            
	and	((coalesce(ie_tipo_item,'N')			         = 'N') or (coalesce(ie_tipo_item,'N') = ie_tipo_item_w))                          
	order by	coalesce(cd_material,0),
			coalesce(cd_classe_material,0),
			coalesce(cd_subgrupo_material,0),
			coalesce(cd_grupo_material,0),
			coalesce(cd_procedimento,0),
			coalesce(ie_origem_proced,0),
			coalesce(cd_grupo_proc,0),
			coalesce(cd_especialidade_proc,0),
			coalesce(cd_area_procedimento,0),
			coalesce(cd_convenio,0),
			coalesce(ie_tipo_atendimento,0),
			coalesce(cd_setor_atendimento,0);
	

	
C03 CURSOR FOR
	SELECT	nm_usuario_aprov,
		nr_nivel_aprov
	from	regra_aprov_audit_regra
	where	nr_seq_regra_aprov = nr_seq_regra_aprov_w
	order by	nr_nivel_aprov;


BEGIN

ie_tipo_ajuste_w := coalesce(obter_valor_param_usuario(1116, 196, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento),'N');

if (coalesce(nr_seq_auditoria_p,0) > 0) then

	select	count(*)
	into STRICT	qt_regra_w
	from	regra_aprovacao_auditoria;
	
	select	max(c.cd_convenio_parametro),
		max(b.ie_tipo_atendimento)
	into STRICT	cd_convenio_w,
		ie_tipo_atendimento_w
	from	auditoria_conta_paciente a,
		conta_paciente c,
		atendimento_paciente b
	where	a.nr_interno_conta = c.nr_interno_conta
	and	c.nr_atendimento   = b.nr_atendimento
	and	a.nr_sequencia	   = nr_seq_auditoria_p;
	
	select	count(*)
	into STRICT	qt_aprovacao_audit_ww
	from	auditoria_aprovacao_item
	where	nr_seq_auditoria = nr_seq_auditoria_p;
		
	
	if (qt_regra_w > 0) then
	
		open C01;
		loop
		fetch C01 into	
			nr_seq_item_w,
			vl_unitario_w,
			dt_item_w,
			ie_tipo_item_w,
			cd_grupo_proc_mat_w,
			cd_subgrupo_espec_w,
			cd_classe_area_w,
			cd_item_w,
			cd_setor_atendimento_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			
			-- Conta os reprovados
			select	count(*)
			into STRICT	qt_aprovacao_audit_w
			from	auditoria_aprovacao_item a
			where	a.nr_seq_auditoria = nr_seq_auditoria_p
			and 	a.nr_seq_item = nr_seq_item_w
			and 	(a.dt_reprovacao IS NOT NULL AND a.dt_reprovacao::text <> '');
			
			-- Conta os nao reprovados
			select	count(*)
			into STRICT	qt_aprovacao_audit_novo_w
			from	auditoria_aprovacao_item a
			where	a.nr_seq_auditoria = nr_seq_auditoria_p
			and 	a.nr_seq_item = nr_seq_item_w
			and 	coalesce(a.dt_reprovacao::text, '') = '';
			
			-- Conta os que nao tem o registro ainda
			select	count(*)
			into STRICT	qt_aprovacao_audit_inicial_w
			from	auditoria_aprovacao_item
			where	nr_seq_auditoria = nr_seq_auditoria_p
			and 	nr_seq_item = nr_seq_item_w;
			
			/* se tiver algum item reprovado e que ainda nao foi gerado o novo,  ou entao nao tiver nenhum item gerado ainda o sistema verificara a regra novamente.*/

			if	(qt_aprovacao_audit_w > 0 AND qt_aprovacao_audit_novo_w = 0) or (qt_aprovacao_audit_inicial_w = 0) then
						
				select	max(cd_estabelecimento)
				into STRICT	cd_estabelecimento_w
				from	auditoria_conta_paciente a,
					conta_paciente b
				where	a.nr_interno_conta = b.nr_interno_conta
				and	a.nr_sequencia = nr_seq_auditoria_p;
				
				open C02;
				loop
				fetch C02 into	
					nr_seq_regra_aprov_w,
					ie_tipo_responsavel_w,
					cd_cargo_w,
					nm_usuario_aprov_w,
					ie_exige_justificativa_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */
					begin
					
					ie_gerou_aprovacao_w	:= 'S';
					
					if (ie_tipo_responsavel_w = 'U') or (ie_tipo_responsavel_w = 'C') then
					
						insert into auditoria_aprovacao_item(
							nr_sequencia,
							nr_seq_auditoria,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							ie_tipo_item,
							nr_seq_item,
							nr_nivel,
							nm_usuario_aprovador,
							cd_cargo_aprovador,
							nr_seq_regra_aprovacao
						) values (
							nextval('auditoria_aprovacao_item_seq'),
							nr_seq_auditoria_p,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							ie_tipo_item_w,
							nr_seq_item_w,
							1,
							nm_usuario_aprov_w,
							cd_cargo_w,
							nr_seq_regra_aprov_w
						);
					
					elsif (ie_tipo_responsavel_w = 'R') then
					
						open C03;
						loop
						fetch C03 into	
							nm_usuario_aprov_regra_w,
							nr_nivel_regra_w;
						EXIT WHEN NOT FOUND; /* apply on C03 */
							begin
							
							insert into auditoria_aprovacao_item(
								nr_sequencia,
								nr_seq_auditoria,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								ie_tipo_item,
								nr_seq_item,
								nr_nivel,
								nm_usuario_aprovador,
								nr_seq_regra_aprovacao
							) values (
								nextval('auditoria_aprovacao_item_seq'),
								nr_seq_auditoria_p,
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								ie_tipo_item_w,
								nr_seq_item_w,
								nr_nivel_regra_w,
								nm_usuario_aprov_regra_w,
								nr_seq_regra_aprov_w
							);
							
							end;
						end loop;
						close C03;
					
					end if;
					
					end;
				end loop;
				close C02;			
				
			end if;
			
			end;
		end loop;
		close C01;			
		
		select 	count(*)
		into STRICT	qt_aprovacao_audit_aprovado_w
		from	auditoria_aprovacao_item
		where	nr_seq_auditoria = nr_seq_auditoria_p
		and 	coalesce(dt_aprovacao::text, '') = '';
		
		if (qt_aprovacao_audit_aprovado_w > 0) then
			ie_gerou_aprovacao_w	:= 'A';
		end if;			
		
		if (qt_aprovacao_audit_ww	= 0) then
			ie_gerou_aprovacao_w	:= 'S';
		end if;
		
		select 	count(*)
		into STRICT	qt_aprovacao_audit_pend_w
		from	auditoria_aprovacao_item
		where	nr_seq_auditoria = nr_seq_auditoria_p
		and 	coalesce(dt_aprovacao::text, '') = ''
		and 	coalesce(dt_reprovacao::text, '') = '';
		
		if (qt_aprovacao_audit_pend_w = 0) then -- Se nao tem nenhum item pendente, ou seja, ja foram aprovados ou reprovados;
			ie_gerou_aprovacao_w	:= 'N';
		end if;		
		
	end if;

end if;

ie_gerou_aprovacao_p	:= ie_gerou_aprovacao_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_audit_aprov_item ( nr_seq_auditoria_p bigint, nm_usuario_p text, ie_gerou_aprovacao_p INOUT text) FROM PUBLIC;

