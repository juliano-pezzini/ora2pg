-- FUNCTION: public.psa_is_configured_datasource()

-- DROP FUNCTION IF EXISTS public.psa_is_configured_datasource();

CREATE OR REPLACE FUNCTION public.psa_is_configured_datasource(
	)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    STABLE SECURITY DEFINER PARALLEL UNSAFE
AS $BODY$
DECLARE

  v_id_datasource   datasource.id%TYPE;
  v_nm_datasource   datasource.nm_datasource%TYPE;

BEGIN
  v_nm_datasource := obter_valor_param_usuario(0, 231, 0, null, 0);
  BEGIN
    SELECT
      id
    INTO STRICT
      v_id_datasource
    FROM
      datasource
    WHERE
        id_application = psa_is_configured()
      AND
        nm_datasource = v_nm_datasource;

    RETURN v_id_datasource;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN NULL;
  END;
END;
$BODY$;

ALTER FUNCTION public.psa_is_configured_datasource()
    OWNER TO postgres;

