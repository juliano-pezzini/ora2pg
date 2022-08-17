-- FUNCTION: public.obter_uso_case(text)

-- DROP FUNCTION IF EXISTS public.obter_uso_case(text);

CREATE OR REPLACE FUNCTION public.obter_uso_case(
	nm_usuario_p text DEFAULT NULL::text)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    STABLE SECURITY DEFINER PARALLEL UNSAFE
AS $BODY$
DECLARE

ds_uso_case_w varchar(1);

cd_estabelecimento_w estabelecimento.cd_estabelecimento%type;
cd_perfil_w perfil.cd_perfil%type;

BEGIN

ds_uso_case_w := 'N';
cd_estabelecimento_w := obter_estabelecimento_ativo();
cd_perfil_w := obter_perfil_ativo();

select 	coalesce(max(case when(ordem IS NOT NULL AND ordem::text <> '') then ie_utiliza_episodio else 'N' end), 'N') ie_utiliza_episodio
into STRICT	ds_uso_case_w
from (SELECT
            case
              when(cd_estabelecimento_w = cd_estabelecimento and cd_perfil_w = cd_perfil) then 1
              when(coalesce(cd_estabelecimento::text, '') = '' and cd_perfil_w = cd_perfil) then 2
              when(cd_estabelecimento = cd_estabelecimento_w and coalesce(cd_perfil::text, '') = '') then 3
              when(coalesce(cd_estabelecimento::text, '') = '' and coalesce(cd_perfil::text, '') = '') then 4
            end ordem, ie_utiliza_episodio, cd_estabelecimento, cd_perfil
    from    parametros_episodio
    order by ordem) alias11 LIMIT 1;

return	ds_uso_case_w;

end;
$BODY$;

ALTER FUNCTION public.obter_uso_case(text)
    OWNER TO postgres;

