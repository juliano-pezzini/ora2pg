CREATE OR REPLACE FUNCTION expressao_pck.obter_dic_expressao_loc(
	cd_expressao_p bigint,
	ds_locale_p text)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE SECURITY DEFINER PARALLEL UNSAFE
AS $BODY$
DECLARE

	ds_retorno_w	varchar(4000);	
	
	ds_idioma_w	varchar(10);
	
	C01 CURSOR FOR
		SELECT	ds_expressao
		from	dic_expressao_idioma
		where	cd_expressao	= cd_expressao_p
		and	ds_idioma	= ds_idioma_w
		and (ds_locale = ds_locale_p or coalesce(ds_locale::text, '') = '')
		order by ds_locale  NULLS LAST;
	
	
BEGIN
	
	if (cd_expressao_p IS NOT NULL AND cd_expressao_p::text <> '') then
		ds_idioma_w	:= substr(ds_locale_p,1,2);
		
		for r_c01 in c01 loop
			begin
			ds_retorno_w	:= r_c01.ds_expressao;
			exit;
			end;
		end loop;
		
		
		if (coalesce(ds_retorno_w::text, '') = '') and
			((ds_locale_p = 'es_DO') or (ds_locale_p = 'es_AR') or (ds_locale_p = 'es_BO') or (ds_locale_p = 'es_CO')) then
			return expressao_pck.obter_dic_expressao_loc(cd_expressao_p,'es_MX');
		elsif (coalesce(ds_retorno_w::text, '') = '') and (ds_locale_p  = 'de_AT') then
			return expressao_pck.obter_dic_expressao_loc(cd_expressao_p,'de_DE');
		elsif (coalesce(ds_retorno_w::text, '') = '') and (ds_locale_p not in ('pt_BR','en_US')) then
			return expressao_pck.obter_dic_expressao_loc(cd_expressao_p,'en_US');
		elsif (coalesce(ds_retorno_w::text, '') = '') and (ds_locale_p	= 'en_US') then
			return expressao_pck.obter_dic_expressao_loc(cd_expressao_p,'pt_BR');
		end if;
		
	end if;
	
	return ds_retorno_w;
	
	END;

$BODY$;

ALTER FUNCTION expressao_pck.obter_dic_expressao_loc(bigint, text)
    OWNER TO postgres;

