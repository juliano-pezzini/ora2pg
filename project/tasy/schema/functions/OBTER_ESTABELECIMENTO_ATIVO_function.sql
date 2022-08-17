
-- FUNCTION: public.obter_estabelecimento_ativo()

-- DROP FUNCTION IF EXISTS public.obter_estabelecimento_ativo();

CREATE OR REPLACE FUNCTION public.obter_estabelecimento_ativo(
	)
    RETURNS bigint
    LANGUAGE 'plpgsql'
    COST 100
    STABLE SECURITY DEFINER PARALLEL UNSAFE
AS $BODY$
DECLARE

estab_ativo_w	bigint;

BEGIN

estab_ativo_w	:= coalesce(wheb_usuario_pck.get_cd_estabelecimento(),1);

return	estab_ativo_w;

end;
$BODY$;

ALTER FUNCTION public.obter_estabelecimento_ativo()
    OWNER TO postgres;

