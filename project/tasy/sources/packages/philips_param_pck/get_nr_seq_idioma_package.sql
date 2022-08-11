-- FUNCTION: philips_param_pck.get_nr_seq_idioma()

-- DROP FUNCTION IF EXISTS philips_param_pck.get_nr_seq_idioma();

CREATE OR REPLACE FUNCTION philips_param_pck.get_nr_seq_idioma(
	)
    RETURNS bigint
    LANGUAGE 'plpgsql'
    COST 100
    STABLE SECURITY DEFINER PARALLEL UNSAFE
AS $BODY$
DECLARE
    idioma_as_text text;
BEGIN
    idioma_as_text = current_setting('philips_param_pck.nr_seq_idioma_w', true);

    if (idioma_as_text is null or trim(idioma_as_text) = '') then
        return 0;
    end if;
		return idioma_as_text::bigint;
	end;

$BODY$;

ALTER FUNCTION philips_param_pck.get_nr_seq_idioma()
    OWNER TO postgres;

