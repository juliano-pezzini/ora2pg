-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_gerar_itens_integracao ( nr_seq_reserva_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
  nr_seq_proc_interno_regra_w	bigint;
  qt_exames_conta_w	integer;
  nr_atendimento_w	bigint;
  cd_estabelecimento_w	smallint;
  ie_tipo_atendimento_w	smallint;
  cd_convenio_w	integer;
  cd_categoria_w	varchar(10);
  ie_tipo_convenio_w	smallint;
  cd_setor_atend_w	integer;
  nr_seq_exame_w	bigint;
  cd_procedimento_w	bigint;
  ie_origem_proced_w	bigint;
  nr_seq_proc_interno_w	bigint;
  nr_seq_integracao_w		bigint;
  nr_seq_integ_item_conta_w	bigint;
  nr_seq_derivado_w	bigint;
  ie_irradiado_w	varchar(1);
  ie_lavado_w	varchar(1);
  ie_filtrado_w	varchar(1);
  ie_aliquotado_w	varchar(1);
  ie_aferese_w	varchar(1);
  ie_pool_w	varchar(1);

  --1º item -exames do receptor: 
  c01 CURSOR FOR 
	SELECT ex.nr_sequencia, 
        ex.cd_procedimento, 
		ex.ie_origem_proced, 
        ex.nr_seq_proc_interno 
	from  san_exame ex, 
		san_exame_realizado er, 
		san_exame_lote el, 
		san_reserva rs 
	where  ex.nr_sequencia = er.nr_seq_exame 
	and	er.nr_seq_exame_lote = el.nr_sequencia 
	and	el.nr_seq_reserva = rs.nr_sequencia 
	and	rs.nr_sequencia = nr_seq_reserva_p 
    group by	ex.nr_sequencia, 
		ex.cd_procedimento, 
		ex.ie_origem_proced, 
		ex.nr_seq_proc_interno 
	order by	ex.cd_procedimento, 
			ex.ie_origem_proced, 
			ex.nr_seq_proc_interno;

  --2º item -exames das bolsas de sangue (hemocomponentes) 
  c02 CURSOR FOR 
	SELECT	ex.nr_sequencia, 
		ex.cd_procedimento, 
		ex.ie_origem_proced, 
		ex.nr_seq_proc_interno, 
		sp.nr_seq_derivado 
	from  san_exame ex, 
		san_exame_realizado er, 
		san_exame_lote el, 
		san_reserva_prod rp, 
		san_producao sp 
	where  ex.nr_sequencia = er.nr_seq_exame 
	and	er.nr_seq_exame_lote = el.nr_sequencia 
	and   el.nr_seq_res_prod = rp.nr_sequencia 
    and	rp.nr_seq_producao = sp.nr_sequencia 
	and	rp.nr_sequencia = nr_seq_reserva_p 
	GROUP BY	ex.nr_sequencia, 
			ex.cd_procedimento, 
			ex.ie_origem_proced, 
			ex.nr_seq_proc_interno, 
			sp.nr_seq_derivado	  
	order by	ex.cd_procedimento, 
			ex.ie_origem_proced, 
			ex.nr_seq_proc_interno;

  --3º item - procedimento de cada bolsa de sangue 
  c03 CURSOR FOR 
	SELECT pr.nr_seq_derivado, 
		dv.cd_procedimento, 
		dv.ie_origem_proced, 
		dv.nr_seq_proc_interno, 
		pr.ie_irradiado, 
		pr.ie_lavado, 
		pr.ie_filtrado, 
		pr.ie_aliquotado, 
		pr.ie_aferese, 
		pr.ie_pool   
	from  san_derivado dv, 
		san_producao pr, 
		san_reserva_prod rp 
	where  dv.nr_sequencia = pr.nr_seq_derivado 
	and   pr.nr_sequencia = rp.nr_seq_producao 
	and	rp.nr_seq_reserva = nr_seq_reserva_p 
	GROUP BY	pr.nr_seq_derivado, 
			dv.cd_procedimento, 
			dv.ie_origem_proced, 
			dv.nr_seq_proc_interno, 
			pr.ie_irradiado, 
			pr.ie_lavado, 
			pr.ie_filtrado, 
			pr.ie_aliquotado, 
			pr.ie_aferese, 
			pr.ie_pool  
	order by	cd_procedimento, 
			dv.ie_origem_proced, 
			dv.nr_seq_proc_interno;


BEGIN 
  
	--buscar dados da reserva 
	select	max(nr_atendimento), 
		max(cd_estabelecimento) 
	into STRICT	nr_atendimento_w, 
		cd_estabelecimento_w 
	from  san_reserva 
	where  nr_sequencia = nr_seq_reserva_p;
   
	--buscar os dados do atendimento: 
	select	max(ie_tipo_atendimento) 
	into STRICT	ie_tipo_atendimento_w 
	from	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_w;
 
	--buscar os dados do convênio: 
	select	max(cd_convenio), 
		max(cd_categoria), 
		max(ie_tipo_convenio) 
	into STRICT	cd_convenio_w, 
		cd_categoria_w, 
		ie_tipo_convenio_w 
	from	atendimento_paciente_v 
	where	nr_atendimento = nr_atendimento_w;
 
	--busca o setor de atendimento 
	cd_setor_atend_w := obter_setor_atendimento(nr_atendimento_w);
 
	--busca a sequencia da integração 
	select	max(sri.nr_sequencia) 
	into STRICT	nr_seq_integracao_w 
	from	san_reserva_integracao sri, 
		san_reserva sr 
	where	sri.nr_seq_reserva = sr.nr_sequencia	  
	and	sr.nr_sequencia = nr_seq_reserva_p;
 
	open c01;
	loop 
	fetch c01 into 
		 nr_seq_exame_w, 
		 cd_procedimento_w, 
		 ie_origem_proced_w, 
		 nr_seq_proc_interno_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
			SELECT * FROM obter_san_proced_convenio(	1,  --exames 
							nr_seq_exame_w, cd_estabelecimento_w, ie_tipo_atendimento_w, ie_tipo_convenio_w, cd_convenio_w, cd_categoria_w, cd_setor_atend_w, cd_procedimento_w, ie_origem_proced_w, 0, nr_seq_proc_interno_w, clock_timestamp(), nr_seq_proc_interno_regra_w, qt_exames_conta_w, 'N', 'N', 'N', 'N', 'N', 'N') INTO STRICT cd_setor_atend_w, cd_procedimento_w, ie_origem_proced_w, nr_seq_proc_interno_regra_w, qt_exames_conta_w;
 
			IF (nr_seq_proc_interno_regra_w IS NOT NULL AND nr_seq_proc_interno_regra_w::text <> '') THEN 
				nr_seq_proc_interno_w	:= nr_seq_proc_interno_regra_w;
			END IF;
 
			if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') or (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') then 
			 
				select	nextval('san_integ_item_conta_seq') 
				into STRICT	nr_seq_integ_item_conta_w 
				;
 
				insert into san_integ_item_conta( 
								nr_sequencia, 
								dt_atualizacao, 
								nm_usuario, 
								dt_atualizacao_nrec, 
								nm_usuario_nrec, 
								nr_seq_res_integracao, 
								nr_seq_proc_interno, 
								cd_procedimento, 
								ie_origem_proced, 
								cd_material) 
							values ( 
								nr_seq_integ_item_conta_w, 
								clock_timestamp(), 
								nm_usuario_p, 
								clock_timestamp(), 
								nm_usuario_p, 
								nr_seq_integracao_w, 
								nr_seq_proc_interno_w, 
								cd_procedimento_w, 
								ie_origem_proced_w, 
								null);
			end if;
 
		end;
	end loop;
	close c01;
 
	/*select	dv.nr_sequencia 
	into	nr_seq_derivado_w 
	from	san_derivado dv, 
		san_producao pr, 
		san_reserva_prod rp--, 
		--san_reserva rs 
	where	dv.nr_sequencia = pr.nr_seq_derivado 
	and	pr.nr_sequencia = rp.nr_seq_producao 
	-- and	  rp.nr_seq_reserva = rs.nr_sequencia 
	and	rp.nr_sequencia = nr_seq_reserva_p;*/
 
 
	open c02;
	loop 
	fetch c02 into 
		 nr_seq_exame_w, 
		 cd_procedimento_w, 
		 ie_origem_proced_w, 
		 nr_seq_proc_interno_w, 
		 nr_seq_derivado_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin 
			SELECT * FROM obter_san_proced_convenio(	1,  --exames 
							nr_seq_exame_w, cd_estabelecimento_w, ie_tipo_atendimento_w, ie_tipo_convenio_w, cd_convenio_w, cd_categoria_w, cd_setor_atend_w, cd_procedimento_w, ie_origem_proced_w, nr_seq_derivado_w, nr_seq_proc_interno_w, clock_timestamp(), nr_seq_proc_interno_regra_w, qt_exames_conta_w, 'N', 'N', 'N', 'N', 'N', 'N') INTO STRICT cd_setor_atend_w, cd_procedimento_w, ie_origem_proced_w, nr_seq_proc_interno_regra_w, qt_exames_conta_w;
 
			IF (nr_seq_proc_interno_regra_w IS NOT NULL AND nr_seq_proc_interno_regra_w::text <> '') THEN 
				nr_seq_proc_interno_w	:= nr_seq_proc_interno_regra_w;
			END IF;
 
			if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') or (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') then 
			 
			  select	nextval('san_integ_item_conta_seq') 
			  into STRICT	 nr_seq_integ_item_conta_w 
			;
 
			  insert into san_integ_item_conta( 
						   nr_sequencia, 
						   dt_atualizacao, 
						   nm_usuario, 
						   dt_atualizacao_nrec, 
						   nm_usuario_nrec, 
						   nr_seq_res_integracao, 
						   nr_seq_proc_interno, 
						   cd_procedimento, 
						   ie_origem_proced, 
						   cd_material) 
						values ( 
							nr_seq_integ_item_conta_w, 
							clock_timestamp(), 
							nm_usuario_p, 
							clock_timestamp(), 
							nm_usuario_p, 
							nr_seq_integracao_w, 
							nr_seq_proc_interno_w, 
							cd_procedimento_w, 
							ie_origem_proced_w, 
							null);
			end if;
 
		end;
	end loop;
	close c02;
 
	open c03;
	loop 
	fetch c03 into 
		 nr_seq_derivado_w, 
		 cd_procedimento_w, 
		 ie_origem_proced_w, 
		 nr_seq_proc_interno_w, 
		 ie_irradiado_w, 
		 ie_lavado_w, 
		 ie_filtrado_w, 
		 ie_aliquotado_w, 
		 ie_aferese_w, 
		 ie_pool_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin 
 
			SELECT * FROM obter_san_proced_convenio(	0,  --hemocomponentes. 
							nr_seq_derivado_w, cd_estabelecimento_w, ie_tipo_atendimento_w, ie_tipo_convenio_w, cd_convenio_w, cd_categoria_w, cd_setor_atend_w, cd_procedimento_w, ie_origem_proced_w, 0, nr_seq_proc_interno_w, clock_timestamp(), nr_seq_proc_interno_regra_w, qt_exames_conta_w, ie_irradiado_w, ie_lavado_w, ie_filtrado_w, ie_aliquotado_w, ie_aferese_w, ie_pool_w) INTO STRICT cd_setor_atend_w, cd_procedimento_w, ie_origem_proced_w, nr_seq_proc_interno_regra_w, qt_exames_conta_w;
 
			IF (nr_seq_proc_interno_regra_w IS NOT NULL AND nr_seq_proc_interno_regra_w::text <> '') THEN 
				nr_seq_proc_interno_w	:= nr_seq_proc_interno_regra_w;
			END IF;
 
			if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') or (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') then 
			 
				select	nextval('san_integ_item_conta_seq') 
				into STRICT	nr_seq_integ_item_conta_w 
				;
 
				insert into san_integ_item_conta( 
								nr_sequencia, 
								dt_atualizacao, 
								nm_usuario, 
								dt_atualizacao_nrec, 
								nm_usuario_nrec, 
								nr_seq_res_integracao, 
								nr_seq_proc_interno, 
								cd_procedimento, 
								ie_origem_proced, 
								cd_material) 
							values ( 
								nr_seq_integ_item_conta_w, 
								clock_timestamp(), 
								nm_usuario_p, 
								clock_timestamp(), 
								nm_usuario_p, 
								nr_seq_integracao_w, 
								nr_seq_proc_interno_w, 
								cd_procedimento_w, 
								ie_origem_proced_w, 
								null);
			end if;
								 
		end;
	end loop;
	close c03;
 
	--atualiza o status para a - atendida 
	update	san_reserva_integracao 
	set	ie_status_requisicao = 'A' 
	where	nr_sequencia = nr_seq_integracao_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_gerar_itens_integracao ( nr_seq_reserva_p bigint, nm_usuario_p text) FROM PUBLIC;

