-- PROCEDURE: public.gerar_log_acesso_funcao(text, bigint, bigint, bigint, text, bigint, bigint)

-- DROP PROCEDURE IF EXISTS public.gerar_log_acesso_funcao(text, bigint, bigint, bigint, text, bigint, bigint);

CREATE OR REPLACE PROCEDURE public.gerar_log_acesso_funcao(
	IN nm_usuario_p text,
	IN cd_funcao_p bigint,
	IN cd_estabelecimento_p bigint,
	IN cd_perfil_p bigint,
	IN ie_tipo_acesso_p text,
	IN nr_seq_acesso_p bigint DEFAULT NULL::bigint,
	INOUT nr_sequencia_p bigint DEFAULT NULL::bigint)
LANGUAGE 'plpgsql'
    SECURITY DEFINER 
AS $BODY$
DECLARE

nr_sequencia_w	bigint;

BEGIN

if (coalesce(cd_estabelecimento_p, 0) > 0) and (coalesce(cd_funcao_p, 0) > 0) and (coalesce(cd_perfil_p, 0) > 0) then

	select nextval('log_acesso_funcao_seq')
	into STRICT nr_sequencia_w
	;

	insert into Log_Acesso_Funcao(
			nr_sequencia,
			cd_estabelecimento,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_funcao,
			dt_acesso,
			cd_perfil,
			ie_tipo_acesso,
			nr_seq_acesso)
	values (
			nr_sequencia_w,
			cd_estabelecimento_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_funcao_p,
			clock_timestamp(),
			cd_perfil_p,
			ie_tipo_acesso_p,
			CASE WHEN nr_seq_acesso_p=0 THEN  null  ELSE nr_seq_acesso_p END );

	nr_sequencia_p	:= nr_sequencia_w;
end if;

-- removed... commit;

END;
$BODY$;
ALTER PROCEDURE public.gerar_log_acesso_funcao(text, bigint, bigint, bigint, text, bigint, bigint)
    OWNER TO postgres;

