-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_autor_mat_esp_convenio ( nr_sequencia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_autor_p INOUT bigint) AS $body$
DECLARE

 
nr_sequencia_w			bigint;
nr_sequencia_mat_w		bigint;
nr_seq_mat_autor_w		bigint;
cd_material_w			bigint;
qt_solicitada_w			double precision;
pr_adicional_w			double precision;
vl_unitario_w			double precision;
vl_total_w			double precision;
ie_valor_conta_w		varchar(2);
ds_observacao_w			varchar(4000);
ie_estagio_autor_w		varchar(2);
ie_reducao_acrescimo_w		varchar(1);
cd_procedimento_principal_w	bigint;
ie_origem_proced_w		bigint;
ie_fornec_mat_autor_esp_w	parametro_faturamento.ie_fornec_mat_autor_esp%type;

c01 CURSOR FOR 
SELECT	a.nr_sequencia, 
	a.cd_material, 
	a.qt_solicitada, 
	a.pr_adicional, 
	a.vl_unitario, 
	a.ie_valor_conta, 
	a.ds_observacao, 
	a.ie_reducao_acrescimo 
from 	material_autorizado a, 
	autorizacao_convenio b 
where	a.nr_sequencia_autor	= b.nr_sequencia 
and	b.nr_sequencia		= nr_sequencia_p;


BEGIN 
 
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then	 
	 
	select	nextval('autorizacao_cirurgia_seq') 
	into STRICT	nr_sequencia_w 
	;
 
	nr_seq_autor_p := nr_sequencia_w;
	 
	select	coalesce(max(ie_estagio_autor),'1'), 
		coalesce(max(ie_fornec_mat_autor_esp),'N') 
	into STRICT	ie_estagio_autor_w, 
		ie_fornec_mat_autor_esp_w 
	from 	parametro_faturamento 
	where	cd_estabelecimento	= cd_estabelecimento_p;
	 
	select	max(cd_procedimento_principal), 
		max(ie_origem_proced) 
	into STRICT	cd_procedimento_principal_w, 
		ie_origem_proced_w 
	from	autorizacao_convenio 
	where	nr_sequencia = nr_sequencia_p;
 
	insert into autorizacao_cirurgia(nr_sequencia, 
			nm_usuario, 
			dt_atualizacao, 
			dt_pedido, 
			nm_usuario_pedido, 
			nr_seq_agenda, 
			nr_atendimento, 
			nr_seq_agenda_consulta, 
			cd_estabelecimento, 
			ie_estagio_autor, 
			nr_prescricao, 
			nr_seq_autor_conv, 
			dt_previsao, 
			cd_pessoa_fisica, 
			cd_procedimento, 
			ie_origem_proced, 
			nr_doc_convenio, 
			cd_senha) 
		SELECT	nr_sequencia_w, 
			nm_usuario_p, 
			clock_timestamp(), 
			clock_timestamp(), 
			nm_usuario_p, 
			a.nr_seq_agenda, 
			a.nr_atendimento, 
			a.nr_seq_agenda_consulta, 
			cd_estabelecimento_p, 
			ie_estagio_autor_w, 
			a.nr_prescricao, 
			a.nr_sequencia, 
			clock_timestamp(), 
			a.cd_pessoa_fisica, 
			cd_procedimento_principal_w, 
			ie_origem_proced_w, 
			a.cd_autorizacao, 
			a.cd_senha 
		from 	autorizacao_convenio a 
		where	a.nr_sequencia		= nr_sequencia_p;
 
	open c01;
	loop 
	fetch c01 into 
		nr_seq_mat_autor_w, 
		cd_material_w, 
		qt_solicitada_w, 
		pr_adicional_w, 
		vl_unitario_w, 
		ie_valor_conta_w, 
		ds_observacao_w, 
		ie_reducao_acrescimo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
 
		select	nextval('material_autor_cirurgia_seq') 
		into STRICT	nr_sequencia_mat_w 
		;
 
		insert	into material_autor_cirurgia(nr_sequencia, 
				nr_seq_autorizacao, 
				nm_usuario, 
				dt_atualizacao, 
				nm_usuario_nrec, 
				dt_atualizacao_nrec, 
				cd_material, 
				qt_solicitada, 
				qt_material, 
				vl_unitario_material, 
				vl_material, 
				ie_aprovacao, 
				ie_valor_conta, 
				ds_observacao, 
				pr_adicional, 
				ie_reducao_acrescimo) 
			values (nr_sequencia_mat_w, 
				nr_sequencia_w, 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				cd_material_w, 
				qt_solicitada_w, 
				0, 
				0, 
				0, 
				'N', 
				ie_valor_conta_w, 
				ds_observacao_w, 
				pr_adicional_w, 
				ie_reducao_acrescimo_w);
 
		insert into material_autor_cir_cot(nr_sequencia, 
				cd_cgc, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				ie_aprovacao, 
				nr_orcamento, 
				vl_unitario_cotado, 
				vl_cotado) 
			SELECT	nr_sequencia_mat_w, 
				a.cd_cgc_fabricante, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				' ', 
				a.nr_orcamento, 
				coalesce(a.vl_cotado,0), 
				(coalesce(a.vl_cotado,0) * a.qt_solicitada) 
			from 	material_autorizado a 
			where	a.nr_sequencia	  = nr_seq_mat_autor_w 
			and	(a.cd_cgc_fabricante IS NOT NULL AND a.cd_cgc_fabricante::text <> '') 
			and	not exists (SELECT 1 
						from 	material_autor_cir_cot x 
						where	x.nr_sequencia					= nr_sequencia_w 
						and	x.cd_cgc					= a.cd_cgc_fabricante 
						and	coalesce(x.nr_orcamento,coalesce(a.nr_orcamento,'X'))	= coalesce(a.nr_orcamento,'X'));
							 
	end loop;
	close c01;
	if (coalesce(ie_fornec_mat_autor_esp_w,'N') = 'S') then 
		CALL gerar_mat_fornec_autor_cot(nr_sequencia_w,nm_usuario_p);
	end if;
	 
 
	update	autorizacao_convenio 
	set	nr_seq_autor_cirurgia	= nr_sequencia_w 
	where	nr_sequencia		= nr_sequencia_p;
	 
	commit;	
 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_autor_mat_esp_convenio ( nr_sequencia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_autor_p INOUT bigint) FROM PUBLIC;
