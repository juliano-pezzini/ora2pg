-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE c03_record AS (
    cd_tributo_bol		tributo.cd_tributo%type
);


CREATE OR REPLACE PROCEDURE gerar_tributo_conta_pac ( nr_interno_conta_p bigint, nr_seq_proc_mat_p bigint, ie_proc_mat_p text, nm_usuario_p text) AS $body$
DECLARE


qt_registros_w		integer;
qt_registros_pacote_w	integer;

cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;

cd_convenio_w		convenio.cd_convenio%type;

cd_procedimento_w	estrutura_procedimento_v.cd_procedimento%type;
ie_origem_proced_w	estrutura_procedimento_v.ie_origem_proced%type;
cd_area_procedimento_w	estrutura_procedimento_v.cd_area_procedimento%type;
cd_especialidade_w	estrutura_procedimento_v.cd_especialidade%type;
cd_grupo_proc_w		estrutura_procedimento_v.cd_grupo_proc%type;

cd_grupo_material_w	estrutura_material_v.cd_grupo_material%type;
cd_subgrupo_material_w	estrutura_material_v.cd_subgrupo_material%type;
cd_classe_material_w	estrutura_material_v.cd_classe_material%type;
cd_material_w		estrutura_material_v.cd_material%type;

cd_tributo_w		tributo.cd_tributo%type;

pr_aliquota_w		regra_calculo_imposto.pr_imposto%type;
nr_seq_regra_w		regra_calculo_imposto.nr_sequencia%type;

nr_seq_propaci_w		propaci_imposto.nr_sequencia%type;
nr_seq_matpaci_w		matpaci_imposto.nr_sequencia%type;

vl_material_w		material_atend_paciente.vl_material%type;
vl_procedimento_w		procedimento_paciente.vl_procedimento%type;
nr_seq_proc_princ_w	procedimento_paciente.nr_seq_proc_princ%type;
ie_item_excluido_w	varchar(1) := 'N';
TYPE c03_type IS TABLE of c03_record INDEX BY integer;
c03_type_w                 c03_type;

C01 CURSOR FOR  --Cursor dos procedimentos para geracao dos impostos quando o item for do pacote
	SELECT	b.cd_procedimento,
		b.ie_origem_proced,
		a.cd_estabelecimento,
		a.cd_convenio_parametro,
		b.vl_procedimento,
		b.nr_seq_proc_princ,
		b.nr_sequencia
	from	conta_paciente a,
		procedimento_paciente b
	where	a.nr_interno_conta = b.nr_interno_conta
	and 	(b.nr_seq_proc_pacote IS NOT NULL AND b.nr_seq_proc_pacote::text <> '')
	and 	b.nr_sequencia = b.nr_seq_proc_pacote
	and 	a.nr_interno_conta = nr_interno_conta_p;
c01_w	c01%rowtype;

C02 CURSOR FOR  --Cursor dos procedimentos e mat med para deletar os impostos quando o item  nao for do pacote
	SELECT	'P' ie_proc_mat,
		b.nr_sequencia
	from	conta_paciente a,
		procedimento_paciente b
	where	a.nr_interno_conta = b.nr_interno_conta
	and 	b.nr_sequencia <> b.nr_seq_proc_pacote
	and 	a.nr_interno_conta = nr_interno_conta_p
	
union

	SELECT	'M' ie_proc_mat,
		b.nr_sequencia
	from	conta_paciente a,
		material_atend_paciente b
	where	a.nr_interno_conta = b.nr_interno_conta
	and 	b.nr_sequencia <> b.nr_seq_proc_pacote
	and 	a.nr_interno_conta = nr_interno_conta_p;
c02_w	c02%rowtype;

C03 CURSOR FOR
	SELECT	
		b.cd_tributo as cod_tributo
	from	regra_calculo_imposto a,
		tributo b,
        tributo_regra_deferido c
	where	a.cd_tributo = b.cd_tributo
    and a.cd_tributo = c.cd_tributo 
    and	b.ie_situacao = 'A'
    and (b.ie_tipo_tributo = 'IVA' or coalesce(pkg_i18n.get_user_locale,'pt_BR') = 'es_BO');

BEGIN

if (nr_seq_proc_mat_p <> 0) and (ie_proc_mat_p IS NOT NULL AND ie_proc_mat_p::text <> '') then
	
	if (ie_proc_mat_p = 'P') then
		select	coalesce(max('N'),'S')
		into STRICT	ie_item_excluido_w
		from	procedimento_paciente
		where	nr_sequencia = nr_seq_proc_mat_p
		and	(nr_interno_conta IS NOT NULL AND nr_interno_conta::text <> '');
	elsif (ie_proc_mat_p = 'M') then
		select	coalesce(max('N'),'S')
		into STRICT	ie_item_excluido_w
		from	material_atend_paciente
		where	nr_sequencia = nr_seq_proc_mat_p
		and	(nr_interno_conta IS NOT NULL AND nr_interno_conta::text <> '');
	end if;
	
end if;

if (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') and (nr_seq_proc_mat_p <> 0) and (ie_proc_mat_p IS NOT NULL AND ie_proc_mat_p::text <> '') and (coalesce(ie_item_excluido_w,'N') = 'N') then
		
	select	sum(qt_registros) qt_registros
	into STRICT	qt_registros_pacote_w
	from (SELECT 	count(*) qt_registros
		from 	procedimento_paciente
		where	nr_sequencia = nr_seq_proc_mat_p
		and	ie_proc_mat_p = 'P'
		and 	coalesce(nr_seq_proc_pacote::text, '') = ''
		
union all

		SELECT 	count(*) qt_registros
		from 	material_atend_paciente
		where	nr_sequencia = nr_seq_proc_mat_p
		and	ie_proc_mat_p = 'M'
		and 	coalesce(nr_seq_proc_pacote::text, '') = '') alias10;
		
	if (ie_proc_mat_p = 'P') then
	
		select	count(*)
		into STRICT	qt_registros_w
		from	propaci_imposto
		where	nr_seq_propaci = nr_seq_proc_mat_p;
	
		if (qt_registros_w > 0) then
			delete from propaci_imposto where nr_seq_propaci = nr_seq_proc_mat_p;
		end if;
	elsif (ie_proc_mat_p = 'M') then
		
		select	count(*)
		into STRICT	qt_registros_w
		from	matpaci_imposto
		where	nr_seq_matpaci = nr_seq_proc_mat_p;
	
		if (qt_registros_w > 0) then
			delete from matpaci_imposto where nr_seq_matpaci = nr_seq_proc_mat_p;
		end if;
		
	end if;
	
		
	if (qt_registros_pacote_w > 0) then
	
		if (ie_proc_mat_p = 'P') then
			
			begin
			select	b.cd_procedimento,
				b.ie_origem_proced,
				a.cd_estabelecimento,
				a.cd_convenio_parametro,
				b.vl_procedimento,
				b.nr_seq_proc_princ
			into STRICT	cd_procedimento_w,
				ie_origem_proced_w,
				cd_estabelecimento_w,
				cd_convenio_w,
				vl_procedimento_w,
				nr_seq_proc_princ_w
			from	conta_paciente a,
				procedimento_paciente b
			where	a.nr_interno_conta = b.nr_interno_conta
			and 	a.nr_interno_conta = nr_interno_conta_p
			and	b.nr_sequencia = nr_seq_proc_mat_p;
			exception
				when others then
				cd_procedimento_w	:= 0;
				ie_origem_proced_w	:= 0;
				cd_estabelecimento_w	:= 1;
				cd_convenio_w		:= 0;
				vl_procedimento_w		:= 0;
			end;
	
			select	coalesce(max(a.cd_grupo_proc),0),
				coalesce(max(a.cd_especialidade),0),
				coalesce(max(a.cd_area_procedimento),0)
			into STRICT	cd_grupo_proc_w,
				cd_especialidade_w,
				cd_area_procedimento_w
			from	estrutura_procedimento_v a
			where	a.cd_procedimento = cd_procedimento_w
			and	a.ie_origem_proced = ie_origem_proced_w;
	
		elsif (ie_proc_mat_p = 'M') then			
	
			begin
			select	b.cd_material,
				a.cd_estabelecimento,
				a.cd_convenio_parametro,
				b.vl_material
			into STRICT	cd_material_w,
				cd_estabelecimento_w,
				cd_convenio_w,
				vl_material_w
			from	conta_paciente a,
				material_atend_paciente b
			where	a.nr_interno_conta = b.nr_interno_conta
			and	a.nr_interno_conta = nr_interno_conta_p
			and	b.nr_sequencia = nr_seq_proc_mat_p;
			exception
				when others then
				cd_material_w		:= 0;
				cd_estabelecimento_w	:= 1;
				cd_convenio_w		:= 0;
				vl_material_w		:= 0;
			end;
	
			select	a.cd_classe_material,
				a.cd_subgrupo_material,
				a.cd_grupo_material
			into STRICT	cd_classe_material_w,
				cd_subgrupo_material_w,
				cd_grupo_material_w
			from	estrutura_material_v a
			where	a.cd_material = cd_material_w;		
	
		end if;
	
		nr_seq_regra_w	:= null;
		cd_tributo_w	:= null;
		pr_aliquota_w	:= 0;
		
		if (coalesce(pkg_i18n.get_user_locale,'pt_BR') = 'es_BO') then

            open c03;
                fetch c03 bulk collect into c03_type_w;
            close c03;

            if (c03_type_w.first IS NOT NULL AND c03_type_w.first::text <> '') then 
            
                for i in c03_type_w.first..c03_type_w.last loop
                
                    SELECT * FROM obter_trib_conta_pac_bol(	cd_estabelecimento_w, cd_convenio_w, clock_timestamp(), coalesce(cd_area_procedimento_w,0), coalesce(cd_especialidade_w,0), coalesce(cd_grupo_proc_w,0), coalesce(cd_procedimento_w,0), coalesce(ie_origem_proced_w,0), coalesce(cd_grupo_material_w,0), coalesce(cd_subgrupo_material_w,0), coalesce(cd_classe_material_w,0), coalesce(cd_material_w,0), c03_type_w[i].cd_tributo_bol, pr_aliquota_w, nr_seq_regra_w) INTO STRICT pr_aliquota_w, nr_seq_regra_w;

                    cd_tributo_w := c03_type_w[i].cd_tributo_bol;

                    
                    if (ie_proc_mat_p = 'P') and (cd_tributo_w IS NOT NULL AND cd_tributo_w::text <> '') and (pr_aliquota_w IS NOT NULL AND pr_aliquota_w::text <> '') then
                
                        select	nextval('propaci_imposto_seq')
                        into STRICT	nr_seq_propaci_w
;

                        insert into propaci_imposto(
                            nr_sequencia,
                            nr_seq_propaci,
                            dt_atualizacao,
                            nm_usuario,
                            dt_atualizacao_nrec,
                            nm_usuario_nrec,
                            cd_tributo,
                            pr_imposto,
                            vl_imposto,
                            nr_seq_regra
                        ) values (
                            nr_seq_propaci_w,
                            nr_seq_proc_mat_p,
                            clock_timestamp(),
                            nm_usuario_p,
                            clock_timestamp(),
                            nm_usuario_p,
                            cd_tributo_w,
                            pr_aliquota_w,
                            (vl_procedimento_w * (pr_aliquota_w / 100)),
                            nr_seq_regra_w);

                    elsif (ie_proc_mat_p = 'M') and (cd_tributo_w IS NOT NULL AND cd_tributo_w::text <> '') and (pr_aliquota_w IS NOT NULL AND pr_aliquota_w::text <> '') then
                
                        select	nextval('matpaci_imposto_seq')
                        into STRICT	nr_seq_matpaci_w
;

                        insert into matpaci_imposto(
                            nr_sequencia,
                            nr_seq_matpaci,
                            dt_atualizacao,
                            nm_usuario,
                            dt_atualizacao_nrec,
                            nm_usuario_nrec,
                            cd_tributo,
                            pr_imposto,
                            vl_imposto,
                            nr_seq_regra
                        ) values (
                            nr_seq_matpaci_w,
                            nr_seq_proc_mat_p,
                            clock_timestamp(),
                            nm_usuario_p,
                            clock_timestamp(),
                            nm_usuario_p,
                            cd_tributo_w,
                            pr_aliquota_w,
                            (vl_material_w * (pr_aliquota_w / 100)),
                            nr_seq_regra_w);

                    elsif (ie_proc_mat_p = 'P') and (nr_seq_proc_princ_w IS NOT NULL AND nr_seq_proc_princ_w::text <> '') then
                    
                        select	count(*)
                        into STRICT	qt_registros_w
                        from	propaci_imposto
                        where	nr_seq_propaci = nr_seq_proc_princ_w;

                        if (qt_registros_w > 0) then
                        
                            select	nextval('propaci_imposto_seq')
                            into STRICT	nr_seq_propaci_w
;

                            insert into propaci_imposto(
                                nr_sequencia,
                                nr_seq_propaci,
                                dt_atualizacao,
                                nm_usuario,
                                dt_atualizacao_nrec,
                                nm_usuario_nrec,
                                cd_tributo,
                                pr_imposto,
                                vl_imposto,
                                nr_seq_regra)
                            SELECT	nr_seq_propaci_w,
                                nr_seq_proc_mat_p,
                                clock_timestamp(),
                                nm_usuario_p,
                                clock_timestamp(),
                                nm_usuario_p,
                                cd_tributo,
                                pr_imposto,
                                CASE WHEN sign(vl_imposto)=-1 THEN  vl_imposto * -1  ELSE vl_imposto END ,
                                nr_seq_regra
                            from	propaci_imposto
                            where	nr_seq_propaci = nr_seq_proc_princ_w;

                        end if;
                    end if;

                
                end loop;

            end if;

		else -- MX
	
		/*select	max(cd_tributo)
		into	cd_tributo_w
		from	tributo
		where	ie_situacao = 'A'
		and	ie_tipo_tributo = 'IVA'
		and	(nvl(cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w);*/
					
		SELECT * FROM obter_dados_trib_conta_pac(	cd_estabelecimento_w, cd_convenio_w, clock_timestamp(), coalesce(cd_area_procedimento_w,0), coalesce(cd_especialidade_w,0), coalesce(cd_grupo_proc_w,0), coalesce(cd_procedimento_w,0), coalesce(ie_origem_proced_w,0), coalesce(cd_grupo_material_w,0), coalesce(cd_subgrupo_material_w,0), coalesce(cd_classe_material_w,0), coalesce(cd_material_w,0), cd_tributo_w, pr_aliquota_w, nr_seq_regra_w) INTO STRICT cd_tributo_w, pr_aliquota_w, nr_seq_regra_w;
	
		if (ie_proc_mat_p = 'P') and (cd_tributo_w IS NOT NULL AND cd_tributo_w::text <> '') and (pr_aliquota_w IS NOT NULL AND pr_aliquota_w::text <> '') then
	
			select	nextval('propaci_imposto_seq')
			into STRICT	nr_seq_propaci_w
			;
	
			insert into propaci_imposto(
				nr_sequencia,
				nr_seq_propaci,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_tributo,
				pr_imposto,
				vl_imposto,
				nr_seq_regra
			) values (
				nr_seq_propaci_w,				--nr_sequencia
				nr_seq_proc_mat_p,			--nr_seq_propaci
				clock_timestamp(),					--dt_atualizacao
				nm_usuario_p,				--nm_usuario
				clock_timestamp(),					--dt_atualizacao_nrec
				nm_usuario_p,				--nm_usuario_nrec
				cd_tributo_w,				--cd_tributo
				pr_aliquota_w,				--pr_imposto
				(vl_procedimento_w * (pr_aliquota_w / 100)),	--vl_imposto
				nr_seq_regra_w);				--nr_seq_regra
	
		elsif (ie_proc_mat_p = 'M') and (cd_tributo_w IS NOT NULL AND cd_tributo_w::text <> '') and (pr_aliquota_w IS NOT NULL AND pr_aliquota_w::text <> '') then
	
			select	nextval('matpaci_imposto_seq')
			into STRICT	nr_seq_matpaci_w
			;
	
			insert into matpaci_imposto(
				nr_sequencia,
				nr_seq_matpaci,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_tributo,
				pr_imposto,
				vl_imposto,
				nr_seq_regra
			) values (
				nr_seq_matpaci_w,			--nr_sequencia
				nr_seq_proc_mat_p,		--nr_seq_matpaci
				clock_timestamp(),				--dt_atualizacao
				nm_usuario_p,			--nm_usuario
				clock_timestamp(),				--dt_atualizacao_nrec
				nm_usuario_p,			--nm_usuario_nrec
				cd_tributo_w,			--cd_tributo
				pr_aliquota_w,			--pr_imposto
				(vl_material_w * (pr_aliquota_w / 100)),	--vl_imposto
				nr_seq_regra_w);			--nr_seq_regra
	
		elsif (ie_proc_mat_p = 'P') and (nr_seq_proc_princ_w IS NOT NULL AND nr_seq_proc_princ_w::text <> '') then
		
			select	count(*)
			into STRICT	qt_registros_w
			from	propaci_imposto
			where	nr_seq_propaci = nr_seq_proc_princ_w;
			
			if (qt_registros_w > 0) then
			
				select	nextval('propaci_imposto_seq')
				into STRICT	nr_seq_propaci_w
				;
			
				insert into propaci_imposto(
					nr_sequencia,
					nr_seq_propaci,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_tributo,
					pr_imposto,
					vl_imposto,
					nr_seq_regra)
				SELECT	nr_seq_propaci_w,
					nr_seq_proc_mat_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_tributo,
					pr_imposto,
					CASE WHEN sign(vl_imposto)=-1 THEN  vl_imposto * -1  ELSE vl_imposto END ,
					nr_seq_regra
				from	propaci_imposto
				where	nr_seq_propaci = nr_seq_proc_princ_w;
	
			end if;
		
		end if;
		end if;
	end if;
end if;

--Esta rotina e executada quando na geracao do pacote em Calcular_Pacote

--Seu objetivo e calcular os impostos sobre os itens rateados do pacote
if (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') and (nr_seq_proc_mat_p = 0) and (ie_proc_mat_p = 'P') then
	
	open C02;
	loop
	fetch C02 into	
		c02_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
			
		if (c02_w.ie_proc_mat = 'P') then
		
			select	count(*)
			into STRICT	qt_registros_w
			from	propaci_imposto
			where	nr_seq_propaci = c02_w.nr_sequencia;
		
			if (qt_registros_w > 0) then
				delete from propaci_imposto where nr_seq_propaci = c02_w.nr_sequencia;
			end if;
		elsif (c02_w.ie_proc_mat = 'M') then
			
			select	count(*)
			into STRICT	qt_registros_w
			from	matpaci_imposto
			where	nr_seq_matpaci = c02_w.nr_sequencia;
		
			if (qt_registros_w > 0) then
				delete from matpaci_imposto where nr_seq_matpaci = c02_w.nr_sequencia;
			end if;
			
		end if;
		end;
	end loop;
	close C02;
	
	
	open C01;
	loop
	fetch C01 into	
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
				
		select	count(*)
		into STRICT	qt_registros_w
		from	propaci_imposto
		where	nr_seq_propaci = c01_w.nr_sequencia;
	
		if (qt_registros_w > 0) then
			delete from propaci_imposto where nr_seq_propaci = c01_w.nr_sequencia;
		end if;
		
		select	coalesce(max(a.cd_grupo_proc),0),
			coalesce(max(a.cd_especialidade),0),
			coalesce(max(a.cd_area_procedimento),0)
		into STRICT	cd_grupo_proc_w,
			cd_especialidade_w,
			cd_area_procedimento_w
		from	estrutura_procedimento_v a
		where	a.cd_procedimento = c01_w.cd_procedimento
		and	a.ie_origem_proced = c01_w.ie_origem_proced;		
	
		nr_seq_regra_w	:= null;
		cd_tributo_w	:= null;
		pr_aliquota_w	:= 0;
	
		/*select	max(cd_tributo)
		into	cd_tributo_w
		from	tributo
		where	ie_situacao = 'A'
		and	ie_tipo_tributo = 'IVA'
		and	(nvl(cd_estabelecimento, c01_w.cd_estabelecimento) = c01_w.cd_estabelecimento);*/
					
		SELECT * FROM obter_dados_trib_conta_pac(	c01_w.cd_estabelecimento, c01_w.cd_convenio_parametro, clock_timestamp(), coalesce(cd_area_procedimento_w,0), coalesce(cd_especialidade_w,0), coalesce(cd_grupo_proc_w,0), coalesce(c01_w.cd_procedimento,0), coalesce(c01_w.ie_origem_proced,0), 0, 0, 0, 0, cd_tributo_w, pr_aliquota_w, nr_seq_regra_w) INTO STRICT cd_tributo_w, pr_aliquota_w, nr_seq_regra_w;
	
		if (cd_tributo_w IS NOT NULL AND cd_tributo_w::text <> '') and (pr_aliquota_w IS NOT NULL AND pr_aliquota_w::text <> '') then
	
			select	nextval('propaci_imposto_seq')
			into STRICT	nr_seq_propaci_w
			;
	
			insert into propaci_imposto(
				nr_sequencia,
				nr_seq_propaci,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_tributo,
				pr_imposto,
				vl_imposto,
				nr_seq_regra
			) values (
				nr_seq_propaci_w,				--nr_sequencia
				c01_w.nr_sequencia,				--nr_seq_propaci
				clock_timestamp(),					--dt_atualizacao
				nm_usuario_p,					--nm_usuario
				clock_timestamp(),					--dt_atualizacao_nrec
				nm_usuario_p,					--nm_usuario_nrec
				cd_tributo_w,					--cd_tributo
				pr_aliquota_w,					--pr_imposto
				(c01_w.vl_procedimento * (pr_aliquota_w / 100)),--vl_imposto
				nr_seq_regra_w);				--nr_seq_regra				
					
		elsif (c01_w.nr_seq_proc_princ IS NOT NULL AND c01_w.nr_seq_proc_princ::text <> '') then
		
			select	count(*)
			into STRICT	qt_registros_w
			from	propaci_imposto
			where	nr_seq_propaci = c01_w.nr_seq_proc_princ;
			
			if (qt_registros_w > 0) then
			
				select	nextval('propaci_imposto_seq')
				into STRICT	nr_seq_propaci_w
				;
			
				insert into propaci_imposto(
					nr_sequencia,
					nr_seq_propaci,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_tributo,
					pr_imposto,
					vl_imposto,
					nr_seq_regra)
				SELECT	nr_seq_propaci_w,
					c01_w.nr_sequencia,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_tributo,
					pr_imposto,
					CASE WHEN sign(vl_imposto)=-1 THEN  vl_imposto * -1  ELSE vl_imposto END ,
					nr_seq_regra
				from	propaci_imposto
				where	nr_seq_propaci = c01_w.nr_seq_proc_princ;
	
			end if;
		
		end if;
		end;
	end loop;
	close C01;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_tributo_conta_pac ( nr_interno_conta_p bigint, nr_seq_proc_mat_p bigint, ie_proc_mat_p text, nm_usuario_p text) FROM PUBLIC;
