
-- PROCEDURE: public.obter_parametros_usuario(bigint, bigint, text, bigint, text)

-- DROP PROCEDURE IF EXISTS public.obter_parametros_usuario(bigint, bigint, text, bigint, text);

CREATE OR REPLACE PROCEDURE public.obter_parametros_usuario(
	IN cd_funcao_p bigint,
	IN cd_perfil_p bigint,
	IN nm_usuario_p text,
	IN cd_estabelecimento_p bigint,
	INOUT vl_parametros_p text)
LANGUAGE 'plpgsql'
    SECURITY DEFINER 
AS $BODY$
DECLARE

vl_parametro_w			text;
vl_parametros_w			text;
nr_sequencia_w			integer;
nr_seq_max_w			integer;
i				integer;

BEGIN

SELECT 	coalesce(max(NR_SEQUENCIA),0)
into STRICT	nr_seq_max_w
FROM 	FUNCAO_PARAMETRO
WHERE 	CD_FUNCAO = cd_funcao_p;

vl_parametros_w			:= '';
nr_sequencia_w			:= 0;

FOR I IN 1 .. nr_seq_max_w LOOP
	begin
	nr_sequencia_w		:= nr_sequencia_w + 1;
call     obter_param_usuario(	cd_funcao_p, nr_sequencia_w, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_parametro_w);
	vl_parametros_w := vl_parametros_w || vl_parametro_w || '#@';
	end;
END LOOP;

vl_parametros_p			:= vl_parametros_w;

END;
$BODY$;
ALTER PROCEDURE public.obter_parametros_usuario(bigint, bigint, text, bigint, text)
    OWNER TO postgres;

