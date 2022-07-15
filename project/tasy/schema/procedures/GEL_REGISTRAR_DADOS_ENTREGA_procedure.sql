-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gel_registrar_dados_entrega (lista_informacao_p text, cd_pessoa_fisica_p text, nm_pessoa_fisica_p text, ds_observacao_p text, ds_documento_p text, nm_usuario_p text, ie_operacao_p text) AS $body$
DECLARE


lista_informacao_w		varchar(4000);
ie_contador_w			bigint	:= 0;
tam_lista_w			bigint;
ie_pos_virgula_w		smallint;
nr_seq_item_malote_w		bigint;				
param50_w  varchar(1);
qtd_itens_malote_w bigint;

/*
	ie_operacao_p
	B - Entrega por Barras
	N - Entrega normal
*/
BEGIN

if (ie_operacao_p = 'N') then
	begin
	lista_informacao_w	:= lista_informacao_p;

	while	(lista_informacao_w IS NOT NULL AND lista_informacao_w::text <> '') or
		ie_contador_w > 200 loop
		begin
		tam_lista_w		:= length(lista_informacao_w);
		ie_pos_virgula_w	:= position(',' in lista_informacao_w);

		if (ie_pos_virgula_w <> 0) then
			nr_seq_item_malote_w	:= substr(lista_informacao_w,1,(ie_pos_virgula_w - 1));
			lista_informacao_w	:= substr(lista_informacao_w,(ie_pos_virgula_w + 1),tam_lista_w);
		end if;

		update	malote_envelope_item
		set	cd_pessoa_retirada	= cd_pessoa_fisica_p,
			nm_pessoa_retirada	= nm_pessoa_fisica_p,
			ds_observacao		= ds_observacao_p,
			ds_documento		= substr(ds_documento_p,1,25),
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_seq_envelope		= nr_seq_item_malote_w;

		ie_contador_w	:= ie_contador_w + 1;

		end;
	end loop;
	end;
elsif (ie_operacao_p = 'B') then
	begin

	update	malote_envelope_item
	set	cd_pessoa_retirada	= cd_pessoa_fisica_p,
		nm_pessoa_retirada	= nm_pessoa_fisica_p,
		ds_observacao		= ds_observacao_p,
		ds_documento		= substr(ds_documento_p,1,25),
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_seq_envelope		= lista_informacao_p;

    --Parametro: Permite realizar entrega de envelopes conferidos sem o processo de geracao do malote
    param50_w := obter_param_usuario(9047, 50, wheb_usuario_pck.get_cd_perfil, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, param50_w);

    select count(*)	
      into STRICT qtd_itens_malote_w
      from malote_envelope_item
	 where to_char(nr_seq_envelope) = lista_informacao_p;

    if (param50_w = 'S' AND qtd_itens_malote_w = 0) then
        update envelope_laudo
           set cd_pessoa_retirada = cd_pessoa_fisica_p,
               nm_pessoa_retirada = nm_pessoa_fisica_p,
               ds_observacao	  = ds_observacao_p,
               ds_documento		  = substr(ds_documento_p,1,25),
               nm_usuario		  = nm_usuario_p,
               dt_atualizacao	  = clock_timestamp()
         where nr_sequencia		  = lista_informacao_p;
    end if;

	end;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gel_registrar_dados_entrega (lista_informacao_p text, cd_pessoa_fisica_p text, nm_pessoa_fisica_p text, ds_observacao_p text, ds_documento_p text, nm_usuario_p text, ie_operacao_p text) FROM PUBLIC;

