-- PROCEDURE: public.tasy_gravar_log_acesso(text, text, text, text, text, text, bigint, text, bigint, bigint, text, text)

-- DROP PROCEDURE IF EXISTS public.tasy_gravar_log_acesso(text, text, text, text, text, text, bigint, text, bigint, bigint, text, text);

CREATE OR REPLACE PROCEDURE public.tasy_gravar_log_acesso(
	IN nm_usuario_p text,
	IN ds_maquina_p text,
	IN nm_usuario_so_p text,
	IN ie_acao_p text,
	IN nm_maq_cliente_p text,
	IN cd_aplicacao_tasy_p text,
	INOUT nr_sequencia_p bigint,
	INOUT ie_acao_excesso_p text,
	IN cd_estabelecimento_p bigint DEFAULT NULL::bigint,
	IN nr_handle_p bigint DEFAULT NULL::bigint,
	IN ds_mac_address_p text DEFAULT NULL::text,
	IN ds_so_maquina_p text DEFAULT NULL::text)
LANGUAGE 'plpgsql'
    SECURITY DEFINER 
AS $BODY$
DECLARE

nm_usuario_so_w		varchar(30);
nm_usuario_bco_w	varchar(10)		:= 'TASY';
qt_usuario_con_w	integer;
qt_usuario_lib_w	integer;
ie_acao_excesso_w	varchar(01);
nr_sequencia_w		bigint;
nr_seq_comunic_w	bigint;
nm_usuario_w		varchar(15);
qt_acesso_invalido_w	bigint;

BEGIN

/* Ações do Log
	N - Acesso Nornal
	T - Tentativa de Acesso
*/
/*Verifica qual o valor para tentativas de acesso inválido*/

qt_acesso_invalido_w :=	(OBTER_VALOR_PARAM_USUARIO(0,84,null,nm_usuario_p,1))::numeric;

if (ie_acao_p = 'N') then
	begin

	select 	coalesce(max(qt_usuario),0),
		coalesce(max(nm_usuario_banco),'TASY'),
		coalesce(max(ie_acao_excesso),'N'),
		coalesce(max(nm_usuario_aviso),'Tasy')
	into STRICT	qt_usuario_lib_w,
		nm_usuario_bco_w,
		ie_acao_excesso_w,
		nm_usuario_w
	from	tasy_licenca c,
		estabelecimento b,
		Usuario a
	where	a.nm_usuario	= nm_usuario_p
	  and	a.cd_estabelecimento	= b.cd_estabelecimento
	  and	b.nr_seq_licenca		= c.nr_sequencia;

	Select	coalesce(nm_usuario_so_p, wheb_usuario_pck.get_nm_usuario())
	into STRICT	nm_usuario_so_w;
    
	select count(1)
	into STRICT	qt_usuario_con_w
	from	usuario_conectado_v
	where	username = nm_usuario_bco_w;

	select nextval('tasy_log_acesso_seq')
	into STRICT	nr_sequencia_w
	;

	nr_sequencia_p		:= nr_sequencia_w;

	Insert into tasy_log_acesso(
		nr_sequencia, nm_usuario, dt_acesso,
		dt_saida, ds_maquina, nm_usuario_so,
		cd_aplicacao_tasy, qt_usuario_lib,
		qt_usuario_con, ie_result_acesso, nm_maq_cliente,
		nr_handle, cd_estabelecimento, ds_mac_address, ds_so_maquina)
	values (
		nr_sequencia_w, Nm_Usuario_p, clock_timestamp(),
		Null, ds_maquina_p, nm_usuario_so_w,
		cd_aplicacao_tasy_p, qt_usuario_lib_w,
		qt_usuario_con_w, 'N', nm_maq_cliente_p,
		nr_handle_p, cd_estabelecimento_p, ds_mac_address_p, ds_so_maquina_p);
	if (qt_usuario_con_w > qt_usuario_lib_w) then
		begin

		ie_acao_excesso_p		:= ie_acao_excesso_w;

		if (ie_acao_excesso_w = 'A') then
			select nextval('comunic_interna_seq')
			into STRICT nr_seq_comunic_w
			;
			insert into comunic_interna(
				dt_comunicado, ds_titulo, ds_comunicado,
				nm_usuario,	dt_atualizacao, ie_geral,
				nm_usuario_destino, nr_sequencia,
				ie_gerencial, dt_liberacao)
			values (
				clock_timestamp(), obter_desc_expressao(782204),
				replace(obter_desc_expressao(782206), '#@QT_USUARIO_LIB_W#@', qt_usuario_lib_w),
				'Tasy', clock_timestamp(), 'N',nm_usuario_w || ',',
				nr_seq_comunic_w, 'N', clock_timestamp());
		end if;
		end;
	end if;

	update	usuario
	set	qt_acesso_invalido = 0
	where	nm_usuario = nm_usuario_p;

	begin
	CALL gerar_Lib_etapa_acesso(clock_timestamp(),cd_estabelecimento_p,nm_usuario_p);
	--insert into felipe(a) values (wheb_usuario_pck.get_cd_estabelecimento);
	exception
		when others then
		null;
	end;

	end;
elsif (ie_acao_p = 'T') then
	begin

	select nextval('tasy_log_acesso_seq')
	into STRICT	nr_sequencia_w
	;

	nr_sequencia_p		:= nr_sequencia_w;

Select	coalesce(nm_usuario_so_p, wheb_usuario_pck.get_nm_usuario())
	into STRICT	nm_usuario_so_w;
    

	Insert into tasy_log_acesso(
		nr_sequencia, nm_usuario, dt_acesso,
		dt_saida, ds_maquina, nm_usuario_so,
		cd_aplicacao_tasy, qt_usuario_lib,
		qt_usuario_con, ie_result_acesso, nm_maq_cliente,
		nr_handle, cd_estabelecimento, ds_mac_address, ds_so_maquina)
	values (
		nr_sequencia_w, Nm_Usuario_p, clock_timestamp(),
		Null, ds_maquina_p, nm_usuario_so_w,
		cd_aplicacao_tasy_p, 0, 0, 'T', nm_maq_cliente_p,
		nr_handle_p, cd_estabelecimento_p, ds_mac_address_p, ds_so_maquina_p);
	end;

	update usuario
	set	qt_acesso_invalido = (coalesce(qt_acesso_invalido,0) + 1)
	where	upper(nm_usuario) = upper(nm_usuario_p);

	update 	usuario
	set	ie_situacao 	  = 'B'
	where	upper(nm_usuario) = upper(nm_usuario_p)
	and	qt_acesso_invalido_w <= qt_acesso_invalido
	and	qt_acesso_invalido_w <> 0;

end if;
-- removed commit
 -- commit;

END;
$BODY$;
ALTER PROCEDURE public.tasy_gravar_log_acesso(text, text, text, text, text, text, bigint, text, bigint, bigint, text, text)
    OWNER TO postgres;

