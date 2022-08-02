-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_vincular_end_ref ( nr_seq_end_ref_p text, cd_pessoa_ref_p text, cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_tipo_complemento_w		smallint;
qt_registro_w			bigint;
nr_sequencia_w			bigint;
ie_lancar_mensagem_alt_w	varchar(10);


BEGIN

if (coalesce(cd_pessoa_ref_p,0) <> 0) and (coalesce(nr_seq_end_ref_p,0) <> 0) then
	select	ie_tipo_complemento
	into STRICT	ie_tipo_complemento_w
	from	compl_pessoa_fisica
	where	nr_sequencia	 = nr_seq_end_ref_p
	and	cd_pessoa_fisica	 = cd_pessoa_ref_p;
	
	select	count(*)
	into STRICT	qt_registro_w
	from	compl_pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	ie_tipo_complemento	= ie_tipo_complemento_w;
	
	if (qt_registro_w	> 0) then
		select	max(nr_sequencia)
		into STRICT	nr_sequencia_w
		from	compl_pessoa_fisica
		where	cd_pessoa_fisica	 = cd_pessoa_fisica_p
		and	ie_tipo_complemento	= ie_tipo_complemento_w;
		
		update	compl_pessoa_fisica
		set	cd_pessoa_end_ref	= cd_pessoa_ref_p,
			nr_seq_end_ref		= nr_seq_end_ref_p,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	cd_pessoa_fisica	= cd_pessoa_fisica_p
		and	ie_tipo_complemento	= ie_tipo_complemento_w;
	else
		select	max(nr_sequencia) + 1
		into STRICT	nr_sequencia_w
		from	compl_pessoa_fisica
		where	cd_pessoa_fisica	 = cd_pessoa_fisica_p;
		
		if (coalesce(nr_sequencia_w::text, '') = '') then
			nr_sequencia_w	:= 1;
		end if;
		
		insert into compl_pessoa_fisica(cd_pessoa_fisica,
			nr_sequencia,
			ie_tipo_complemento,
			dt_atualizacao,
			nm_usuario,
			nr_seq_end_ref,
			cd_pessoa_end_ref)
		values (cd_pessoa_fisica_p,
			nr_sequencia_w,
			ie_tipo_complemento_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_end_ref_p,
			cd_pessoa_ref_p);
	end if;
	
	ie_lancar_mensagem_alt_w := pls_atualizar_compl_pf(cd_pessoa_fisica_p, nr_sequencia_w, cd_estabelecimento_p, nm_usuario_p, 'N');
	
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_vincular_end_ref ( nr_seq_end_ref_p text, cd_pessoa_ref_p text, cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

