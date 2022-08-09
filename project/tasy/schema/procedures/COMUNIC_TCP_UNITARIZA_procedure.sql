-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE comunic_tcp_unitariza (nr_seq_lote_p bigint) AS $body$
DECLARE


c 	utl_tcp.connection;  -- TCP/IP connection to the Web server  
x	integer;

ds_material_w			varchar(255);
ds_barras_w			varchar(11);
dt_validade_w			varchar(10);
ds_lote_fornec_w			varchar(20);
cd_material_w			bigint;
ds_mensagem_w			varchar(4000);
ds_mat_reduzido_w		varchar(4000);
ds_texto_w			varchar(4000);
nm_objeto_w			varchar(255);
nr_ip_w				varchar(100);
nr_porta_w			varchar(40);
cd_classe_material_w		bigint;
cd_subgrupo_material_w		bigint;
cd_grupo_material_w		bigint;
cd_estabelecimento_w		bigint;
ds_marca_w			varchar(150);
nr_sequencia_w			material_lote_fornec.nr_sequencia%type;
nr_digito_verif_w			material_lote_fornec.nr_digito_verif%type;
ds_ficha_tecnica_w			varchar(80);
ds_observacao_w			material_lote_fornec.ds_observacao%type;
ie_via_aplicacao_w		material.ie_via_aplicacao%type;
ds_via_aplicacao_w 		via_aplicacao.ds_via_aplicacao%type;
cd_perfil_w				perfil.cd_perfil%type;


c01 CURSOR FOR
SELECT	nm_objeto,
	nr_ip,
	nr_porta,
	ds_texto
from	regra_comunic_unitariza a
where	cd_estabelecimento = cd_estabelecimento_w
and	coalesce(cd_material,cd_material_w) = cd_material_w
and	coalesce(cd_grupo_material,cd_grupo_material_w) = cd_grupo_material_w
and	coalesce(cd_subgrupo_material,cd_subgrupo_material_w) = cd_subgrupo_material_w
and	coalesce(cd_classe_material,cd_classe_material_w) = cd_classe_material_w
and	coalesce(cd_perfil,cd_perfil_w) = cd_perfil_w
and	ie_situacao = 'A'
order by cd_material desc,
	cd_classe_material desc,
	cd_subgrupo_material desc,
	cd_grupo_material desc;



BEGIN
begin
cd_perfil_w := wheb_usuario_pck.get_cd_perfil;

select	a.nr_sequencia,
	a.nr_digito_verif,
	a.ds_lote_fornec,
	to_char(a.dt_validade,'dd/mm/yyyy'),
	adiciona_zeros_esquerda(a.nr_sequencia||nr_digito_verif,11),
	a.cd_material,
	b.ds_material,
	a.cd_estabelecimento,
	substr(obter_desc_redu_material(B.CD_MATERIAL),1,255),
	substr(obter_descricao_padrao('MEDIC_FICHA_TECNICA', 'DS_SUBSTANCIA',b.nr_seq_ficha_tecnica),1,80),
	substr(obter_desc_marca(a.nr_seq_marca),1,150),
	a.ds_observacao,
	b.ie_via_aplicacao
into STRICT	nr_sequencia_w,
	nr_digito_verif_w,
	ds_lote_fornec_w,
	dt_validade_w,
	ds_barras_w,
	cd_material_w,
	ds_material_w,
	cd_estabelecimento_w,
	ds_mat_reduzido_w,
	ds_ficha_tecnica_w,
	ds_marca_w,
	ds_observacao_w,
	ie_via_aplicacao_w
from	material_lote_fornec a,
	material b
where	a.cd_material = b.cd_material
and	a.nr_sequencia = nr_seq_lote_p;	

select	max(ds_via_aplicacao)
	into STRICT	ds_via_aplicacao_w
	from	via_aplicacao
	where	ie_via_aplicacao = ie_via_aplicacao_w;
	
exception
when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(253484,'NR_SEQ_LOTE_W=' || nr_seq_lote_p || ';DS_ERRO_W=' || sqlerrm);
end;

if (cd_material_w > 0) then

	select	cd_grupo_material,
		cd_subgrupo_material,
		cd_classe_material
	into STRICT	cd_grupo_material_w,
		cd_subgrupo_material_w,
		cd_classe_material_w
	from	estrutura_material_v
	where	cd_material = cd_material_w;

	open C01;
	loop
	fetch C01 into	
		nm_objeto_w,
		nr_ip_w,
		nr_porta_w,
		ds_texto_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin		
		nm_objeto_w		:= nm_objeto_w;
		nr_ip_w			:= nr_ip_w;
		nr_porta_w		:= nr_porta_w;		
		ds_texto_w		:= ds_texto_w;	
		end;
	end loop;
	close C01;
	
		
	select	substr(
		replace(
		replace(
		replace(
		replace(
		replace(
		replace(
		replace(
		replace(
		replace(
		replace(
		replace(
		replace(
			ds_texto_w,
			'@cd_material', cd_material_w),
			'@ds_material', ds_material_w),
			'@dt_validade', dt_validade_w),
			'@ds_lote_fornec', ds_lote_fornec_w),
			'@ds_barras', ds_barras_w),
			'@nr_digito_verif', nr_digito_verif_w),
			'@nr_sequencia', nr_sequencia_w),
			'@ds_mat_reduzido', ds_mat_reduzido_w),
			'@ds_marca', ds_marca_w),
			'@ds_principio_ativo', ds_ficha_tecnica_w),
			'@ds_observacao', ds_observacao_w),
			'@ie_via_aplicacao', ds_via_aplicacao_w),1,4000)
			
	into STRICT	ds_mensagem_w
	;
	
	ds_mensagem_w	:= substr(chr(2) || ds_mensagem_w || chr(3),1,4000);
	
	begin
	
	c := utl_tcp.open_connection(nr_ip_w, nr_porta_w);	
	exception
	when others then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(253485,'DS_ERRO_W=' || sqlerrm);
	end;
	
	begin
	x := utl_tcp.write_line(c, ds_mensagem_w);
	exception
	when others then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(253486,'DS_ERRO_W=' || sqlerrm);
	end;
	
	begin
	x := utl_tcp.write_line(c);
	exception
	when others then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(253487,'DS_ERRO_W=' || sqlerrm);
	end;

	begin
	utl_tcp.close_connection(c);
	exception
	when others then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(253488,'DS_ERRO_W=' || sqlerrm);
	end;			
end if;

	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE comunic_tcp_unitariza (nr_seq_lote_p bigint) FROM PUBLIC;
