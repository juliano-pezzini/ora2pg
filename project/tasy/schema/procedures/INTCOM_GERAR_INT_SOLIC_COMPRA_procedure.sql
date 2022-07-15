-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intcom_gerar_int_solic_compra ( nr_solic_compra_p bigint, ds_xml_p text, ie_tipo_integracao_p text, nm_usuario_p text, ie_forma_integra_p text, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


nr_seq_registro_w	bigint;
ds_tipo_operacao_w	varchar(30);
ds_login_w		varchar(255);
ds_senha_w		varchar(255);
cd_material_w		integer;
ds_material_w		varchar(255);
ds_lista_materiais_w	varchar(4000) := '';
nr_sequencia_w		bigint;
ds_historico_w		varchar(4000);
ds_log_w		    varchar(2000);
machine_w	varchar(200);
osuser_w	varchar(200);
program_w	varchar(200);
ie_solic_aprovada_w integer;

c01 CURSOR FOR
SELECT	cd_material,
	substr(obter_desc_material(cd_material),1,255)
from	solic_compra_item
where	nr_solic_compra = nr_solic_compra_p
and	obter_se_integra_sc_item(nr_solic_compra, cd_material) = 'N';


BEGIN

nr_sequencia_w := 0;

select count(*)
  into STRICT ie_solic_aprovada_w
  from solic_compra
 where nr_solic_compra = nr_solic_compra_p
   and (dt_autorizacao IS NOT NULL AND dt_autorizacao::text <> '');

if (ie_solic_aprovada_w = 0) then
	begin
		select	coalesce(machine,'Nao Ident'),
				coalesce(osuser,'Nao Ident'),
				coalesce(program,'Nao Ident')
		  into STRICT	machine_w,
					osuser_w,
				  program_w
		  from	v$session
		 where	audsid = (SELECT userenv('sessionid') );
		ds_log_w := substr('nr_solic_compra:' || nr_solic_compra_p || ';ie_forma_integra_p=' || ie_forma_integra_p || ';ds_stack=' || dbms_utility.format_call_stack || ';cd_funcao=' ||
		wheb_usuario_pck.get_cd_funcao || ';machine=' || machine_w || ';os_user=' || osuser_w || ';program=' || program_w, 1, 2000);

		CALL gravar_log_tasy(78965, ds_log_w, nm_usuario_p);

	exception when others then
	CALL gravar_log_tasy(78965, 'Erro ao gravar log', nm_usuario_p);
	end;

else

	if (ie_forma_integra_p = 'M') then
		CALL postergar_entregas_solic(nr_solic_compra_p, 'M', 'S', nm_usuario_p);	

		ds_historico_w	:= 	wheb_mensagem_pck.get_texto(303527);
	elsif (ie_forma_integra_p = 'L') then
		ds_historico_w	:= 	wheb_mensagem_pck.get_texto(303528);
	elsif (ie_forma_integra_p = 'A') then
		ds_historico_w	:= 	wheb_mensagem_pck.get_texto(303529);
	elsif (ie_forma_integra_p = 'C') then
		ds_historico_w	:= 	wheb_mensagem_pck.get_texto(303530);
	elsif (ie_forma_integra_p = 'G') then
		ds_historico_w	:= 	wheb_mensagem_pck.get_texto(303531);
	end if;

	select	CASE WHEN ie_tipo_integracao_p='BCD' THEN 'WAS' WHEN ie_tipo_integracao_p='BCE' THEN 'WASE' END
	into STRICT	ds_tipo_operacao_w
	;

	select	nextval('registro_integr_compras_seq')
	into STRICT	nr_seq_registro_w
	;

	select	a.ds_login_integr_compras_ws,
		a.ds_senha_integr_compras_ws
	into STRICT	ds_login_w,
		ds_senha_w
	from	parametro_compras a,
		solic_compra b
	where	a.cd_estabelecimento	= b.cd_estabelecimento
	and	b.nr_solic_compra	= nr_solic_compra_p;

	insert into registro_integr_compras(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_tipo_operacao,
		nr_solic_compra)
	values (	nr_seq_registro_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,	
		ds_tipo_operacao_w,
		nr_solic_compra_p);
		
	select	nextval('registro_integr_com_xml_seq')
	into STRICT	nr_sequencia_w
	;

	insert into registro_integr_com_xml(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_registro,
		ie_status,
		ie_operacao,
		ie_sistema_origem,
		ds_erro,
		ds_retorno,
		ds_xml,
		ie_tipo_operacao,
		ds_login,
		ds_senha)
	values (	nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_registro_w,
		'NP',
		'E',
		'TASY',
		null,
		null,
		ds_xml_p,
		ds_tipo_operacao_w,
		ds_login_w,
		ds_senha_w);

	insert into solic_compra_hist(	
		nr_sequencia,
		nr_solic_compra,
		dt_atualizacao,
		nm_usuario,
		dt_historico,
		ds_titulo,
		ds_historico,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_tipo,
		cd_evento,
		dt_liberacao)
	values (	nextval('solic_compra_hist_seq'),
		nr_solic_compra_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		wheb_mensagem_pck.get_texto(303518),
		ds_historico_w,
		clock_timestamp(),
		nm_usuario_p,
		'S',
		'U',
		clock_timestamp());
		
	open C01;
	loop
	fetch C01 into	
		cd_material_w,
		ds_material_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		ds_lista_materiais_w := substr(ds_lista_materiais_w || cd_material_w || ' - ' || ds_material_w || chr(13) || chr(10),1,4000);
		end;
	end loop;
	close C01;	

	if (ds_lista_materiais_w IS NOT NULL AND ds_lista_materiais_w::text <> '') then
		
		insert into solic_compra_hist(	
			nr_sequencia,
			nr_solic_compra,
			dt_atualizacao,
			nm_usuario,
			dt_historico,
			ds_titulo,
			ds_historico,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_tipo,
			cd_evento,
			dt_liberacao)
		values (	nextval('solic_compra_hist_seq'),
			nr_solic_compra_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			wheb_mensagem_pck.get_texto(303532),
			ds_lista_materiais_w,
			clock_timestamp(),
			nm_usuario_p,
			'S',
			'U',
			clock_timestamp());
	end if;

end if;

commit;

nr_sequencia_p	:= nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intcom_gerar_int_solic_compra ( nr_solic_compra_p bigint, ds_xml_p text, ie_tipo_integracao_p text, nm_usuario_p text, ie_forma_integra_p text, nr_sequencia_p INOUT bigint) FROM PUBLIC;

