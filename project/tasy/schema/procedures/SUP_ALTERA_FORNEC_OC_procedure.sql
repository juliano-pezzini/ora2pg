-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_altera_fornec_oc ( nr_ordem_compra_p bigint, cd_cgc_novo_p text, nm_usuario_p text) AS $body$
DECLARE

 
qt_existe_w		bigint;
cd_cgc_w		varchar(20);
cd_cgc_fornecedor_w	varchar(14);
ds_razao_velha_w	varchar(100);
ds_razao_nova_w		varchar(100);
ds_historico_w		varchar(2000);
ie_sistema_origem_w	varchar(15);


BEGIN 
 
select	cd_cgc_fornecedor, 
	substr(obter_nome_pf_pj(null, cd_cgc_fornecedor),1,100) 
into STRICT	cd_cgc_fornecedor_w, 
	ds_razao_velha_w 
from	ordem_compra 
where	nr_ordem_compra = nr_ordem_compra_p;
 
select	count(*) 
into STRICT	qt_existe_w 
from	pessoa_juridica 
where	cd_cgc = cd_cgc_novo_p;
 
if (qt_existe_w > 0) then 
	begin 
 
	select	max(ie_sistema_origem) 
	into STRICT	ie_sistema_origem_w 
	from	ordem_compra 
	where	nr_ordem_compra = nr_ordem_compra_p;
	 
	if (ie_sistema_origem_w IS NOT NULL AND ie_sistema_origem_w::text <> '') then 
		 
		update	ordem_compra 
		set	ie_necessita_enviar_int	= 'S', 
			nm_usuario_altera_int	= nm_usuario_p 
		where	nr_ordem_compra		= nr_ordem_compra_p;
	 
	end if;
	 
	update	ordem_compra 
	set	cd_cgc_fornecedor = cd_cgc_novo_p 
	where	nr_ordem_compra = nr_ordem_compra_p;
	 
	select	substr(obter_nome_pf_pj(null, cd_cgc_novo_p),1,100) 
	into STRICT	ds_razao_nova_w 
	;
	 
	 
	ds_historico_w := substr(WHEB_MENSAGEM_PCK.get_texto(306710,'CD_CGC_FORNECEDOR_W=' || cd_cgc_fornecedor_w || ';' || 'DS_RAZAO_VELHA_W=' || ds_razao_velha_w || ';' || 
									'CD_CGC_NOVO_P=' || cd_cgc_novo_p || ';' || 'DS_RAZAO_NOVA_W=' || ds_razao_nova_w),1,2000);
				 
	 
 
	end;
else	 
	begin 
 
	cd_cgc_w	:= ('0' || cd_cgc_novo_p);
 
	select	count(*) 
	into STRICT	qt_existe_w 
	from	pessoa_juridica 
	where	cd_cgc = cd_cgc_w;
 
	if (qt_existe_w > 0) then 
		begin 
		 
		select	max(ie_sistema_origem) 
		into STRICT	ie_sistema_origem_w 
		from	ordem_compra 
		where	nr_ordem_compra = nr_ordem_compra_p;
		 
		if (ie_sistema_origem_w IS NOT NULL AND ie_sistema_origem_w::text <> '') then 
			 
			update	ordem_compra 
			set	ie_necessita_enviar_int	= 'S', 
				nm_usuario_altera_int	= nm_usuario_p 
			where	nr_ordem_compra		= nr_ordem_compra_p;
		 
		end if;
 
		update	ordem_compra 
		set	cd_cgc_fornecedor = cd_cgc_w 
		where	nr_ordem_compra = nr_ordem_compra_p;
		 
		select	substr(obter_nome_pf_pj(null, cd_cgc_novo_p),1,100) 
		into STRICT	ds_razao_nova_w 
		;
		 
		ds_historico_w := substr(WHEB_MENSAGEM_PCK.get_texto(306710,'CD_CGC_FORNECEDOR_W=' || cd_cgc_fornecedor_w || ';' || 'DS_RAZAO_VELHA_W=' || ds_razao_velha_w || ';' || 
									'CD_CGC_NOVO_P=' || cd_cgc_novo_p || ';' || 'DS_RAZAO_NOVA_W=' || ds_razao_nova_w),1,2000);
 
					 
		end;
 
	end if;
	end;
end if;
 
if (ds_historico_w IS NOT NULL AND ds_historico_w::text <> '') then	 
 
	insert into ordem_compra_hist( 
		nr_sequencia, 
		nr_ordem_compra, 
		dt_atualizacao, 
		nm_usuario, 
		dt_historico, 
		ds_titulo, 
		ds_historico, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		ie_tipo, 
		dt_liberacao, 
		ie_motivo_hist) 
	values (	nextval('ordem_compra_hist_seq'), 
		nr_ordem_compra_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		substr(WHEB_MENSAGEM_PCK.get_texto(306709),1,80), 
		substr(ds_historico_w,1,400), 
		clock_timestamp(), 
		nm_usuario_p, 
		'S', 
		clock_timestamp(), 
		'F');
	 
/*	 
	inserir_historico_ordem_compra( 
		nr_ordem_compra_p, 
		'S', 
		'Alteração fornecedor', 
		ds_historico_w, 
		nm_usuario_p); 
*/
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_altera_fornec_oc ( nr_ordem_compra_p bigint, cd_cgc_novo_p text, nm_usuario_p text) FROM PUBLIC;

