-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_relat_medic_custovenda ( cd_convenio_p bigint, cd_material_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_desconto_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
cd_convenio_w		integer;
cd_material_w		integer;
ds_material_w		varchar(255);
qt_material_w		double precision;
cd_unidade_medida_w	varchar(30);
vl_preco_custo_w	double precision;
vl_preco_venda_conv_w	double precision;
ds_comando_w		varchar(2000);
nr_count_w		bigint;

C01 CURSOR FOR 
SELECT	/*+ cluster(material_atend_paciente)*/ 
	a.cd_convenio, 
	a.cd_material cd_mat, 
	substr(b.ds_material,1,100) ds_material, 
	sum(a.qt_material) qt_material, 
	a.cd_unidade_medida, 
	coalesce((obter_preco_custo_material(a.cd_material,cd_estabelecimento_p) * sum(a.qt_material)) / (b.qt_conv_estoque_consumo * b.qt_conv_compra_estoque),0) vl_preco_custo, 
	CASE WHEN ie_desconto_p='S' THEN coalesce(((obter_preco_venda(a.cd_material,'C') * sum(a.qt_material)) * 0.90),0) WHEN ie_desconto_p='N' THEN coalesce((obter_preco_venda(a.cd_material,'C') * sum(a.qt_material)),0) END  vl_preco_venda_conv 
from	material_atend_paciente a, 
	conta_paciente c, 
	material b 
where	a.cd_material = b.cd_material 
and	a.nr_interno_conta = c.nr_interno_conta 
and	c.ie_status_acerto = 2 - 0 
and	b.ie_tipo_material in (2, 3) 
and	a.dt_atendimento >= dt_inicial_p - 0 
and	a.dt_atendimento <= dt_final_p - 0 
and	((a.cd_material = cd_material_p) or (coalesce(cd_material_p::text, '') = '')) 
and	(((a.cd_convenio = cd_convenio_p) and (cd_convenio_p <> 24) and (ie_desconto_p = 'N')) or ((a.cd_convenio = cd_convenio_p) and (cd_convenio_p = 24) and (ie_desconto_p = 'S'))) 
group by	a.cd_material, 
		substr(b.ds_material,1,100), 
		a.cd_convenio, 
		a.cd_unidade_medida, 
		b.qt_conv_estoque_consumo, 
		b.qt_conv_compra_estoque;


BEGIN 
 
/* Verifica a existência da tabela */
 
 
begin 
Select	count(table_name) 
into STRICT	nr_count_w 
from	user_tables 
where	upper(table_name) = 'MEDICAMENTO_CUSTOVENDA_W';
 
	if (nr_count_w = 0) then 
		CALL EXEC_SQL_DINAMICO('TASY','create table medicamento_custovenda_w	( cd_convenio number(5),cd_material number(6),ds_material varchar2(100),qt_material number,cd_unidade_medida varchar2(5),vl_preco_custo number(15,4),vl_preco_venda number(15,4))');
	else 
		CALL EXEC_SQL_DINAMICO('TASY','drop table medicamento_custovenda_w');
		CALL EXEC_SQL_DINAMICO('TASY','create table medicamento_custovenda_w	( cd_convenio number(5),cd_material number(6),ds_material varchar2(100),qt_material number,cd_unidade_medida varchar2(5),vl_preco_custo number(15,4),vl_preco_venda number(15,4))');
	end if;
 
commit;
end;
 
Open C01;
LOOP 
	Fetch C01 into	cd_convenio_w, 
			cd_material_w, 
			ds_material_w, 
			qt_material_w, 
			cd_unidade_medida_w, 
			vl_preco_custo_w, 
			vl_preco_venda_conv_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
 
	ds_comando_w	:= 	'insert	into medicamento_custovenda_w 
					values (' || cd_convenio_w || ', ' || cd_material_w || ', ' || 
						chr(39) || ds_material_w || chr(39) || ', ' || qt_material_w || ', ' || 
						chr(39) || cd_unidade_medida_w || chr(39) || ', ' || replace(to_char(vl_preco_custo_w),',','.') || 
						 ', ' || replace(to_char(vl_preco_venda_conv_w),',','.') || ')';
	CALL EXEC_SQL_DINAMICO('TASY',ds_comando_w);
 
end loop;
close C01;
 
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_relat_medic_custovenda ( cd_convenio_p bigint, cd_material_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_desconto_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

