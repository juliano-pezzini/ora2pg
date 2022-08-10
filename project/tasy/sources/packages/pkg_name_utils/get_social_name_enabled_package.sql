CREATE OR REPLACE FUNCTION pkg_name_utils.get_social_name_enabled(
cd_estabelecimento_p bigint DEFAULT NULL::bigint)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE SECURITY DEFINER PARALLEL UNSAFE
AS $BODY$
DECLARE
ds_key_w        varchar2(255);
cd_estab_w      bigint;
ie_social_name_w varchar2(255);
begin
cd_estab_w      := nvl(cd_estabelecimento_p,nvl(wheb_usuario_pck.get_cd_estabelecimento(),1));
ds_key_w        := cd_estab_w;

/*
if      (vetor_w.exists(ds_key_w)) then
        return vetor_w(ds_key_w).ie_social_name;
else
        vetor_w(ds_key_w).cd_estabelecimento    := ds_key_w;


        select  nvl(max(ie_nome_social),'N')
        into    vetor_w(ds_key_w).ie_social_name
        from    estabelecimento
        where   cd_estabelecimento = cd_estab_w;

        return vetor_w(ds_key_w).ie_social_name;

*/

        select  nvl(max(ie_nome_social),'N')
        into    ie_social_name_w
        from    estabelecimento
        where   cd_estabelecimento = cd_estab_w;

return ie_social_name_w;
END;

$BODY$;

ALTER FUNCTION pkg_name_utils.get_social_name_enabled(bigint)
    OWNER TO postgres;

