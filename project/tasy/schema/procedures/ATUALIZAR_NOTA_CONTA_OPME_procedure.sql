-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_nota_conta_opme ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ie_consignado_mat_w		varchar(01);
nr_atendimento_w			bigint;
nr_prescricao_w			bigint;
nr_nota_fiscal_w			varchar(255);
nr_sequencia_nf_w			bigint;
nr_seq_matpaci_w			bigint;
qt_registro_w			bigint;
cd_material_w			integer;
dt_emissao_w			timestamp;
nr_ordem_compra_w		bigint;
vl_total_nota_w			nota_fiscal.vl_total_nota%type;

c01 CURSOR FOR 
SELECT	a.nr_sequencia_nf, 
	a.cd_material 
from	nota_fiscal_item a 
where	a.nr_sequencia = nr_sequencia_p 
and	(a.nr_ordem_compra IS NOT NULL AND a.nr_ordem_compra::text <> '');


BEGIN 
 
select	coalesce(max(nr_ordem_compra),0), 
	coalesce(max(somente_numero(nr_nota_fiscal)),0), 
	max(dt_emissao), 
	max(vl_total_nota) 
into STRICT	nr_ordem_compra_w, 
	nr_nota_fiscal_w, 
	dt_emissao_w, 
	vl_total_nota_w 
from	nota_fiscal 
where	nr_sequencia	= nr_sequencia_p;
 
if (nr_ordem_compra_w > 0) then 
	 
	select	coalesce(max(nr_atendimento),0), 
		coalesce(max(nr_prescricao),0) 
	into STRICT	nr_atendimento_w, 
		nr_prescricao_w 
	from	ordem_compra 
	where	nr_ordem_compra = nr_ordem_compra_w;
 
	open c01;
	loop 
	fetch c01 into 
		nr_sequencia_nf_w, 
		cd_material_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		ie_consignado_mat_w	:= coalesce(obter_se_mat_consignado(cd_material_w),'0');
		/* Atualizar a nota fiscal do material automaticamente na Conta: MAT_ATEND_PACIENTE_OPME */
 
		if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') and (ie_consignado_mat_w in ('1','2')) then 
			begin 
			/*Obter sequencia da material_atend_paciente */
 
			select	coalesce(max(nr_sequencia),0) 
			into STRICT	nr_seq_matpaci_w 
			from	material_atend_paciente 
			where	nr_atendimento	= nr_atendimento_w 
			and	coalesce(nr_prescricao, 0)	= coalesce(nr_prescricao_w, 0) 
			and	cd_material	= cd_material_w 
			and	coalesce(qt_devolvida,0) = 0;
 
			/* Se ja existe NF associada ao item da conta */
 
			select	count(*) 
			into STRICT	qt_registro_w 
			from	mat_atend_paciente_opme 
			where	nr_seq_material	= nr_seq_matpaci_w;
					 
			/* Atualiza a tabela de OPME dos consignados*/
 
			if (nr_seq_matpaci_w > 0) and (qt_registro_w = 0) then 
				insert into mat_atend_paciente_opme( 
					nr_sequencia, 
					nr_seq_material, 
					nr_nota_fiscal, 
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					nr_sequencia_nf, 
					dt_emissao, 
					nr_seq_nf, 
					vl_item_nf) 
				values (	nextval('mat_atend_paciente_opme_seq'), 
					nr_seq_matpaci_w, 
					nr_nota_fiscal_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					nr_sequencia_nf_w, 
					dt_emissao_w, 
					nr_sequencia_p, 
					vl_total_nota_w);
			end if;
			end;
		end if;
	end loop;
	close c01;
end if;
				 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_nota_conta_opme ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

